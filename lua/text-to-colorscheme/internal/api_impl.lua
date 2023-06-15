local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local ipairs = _tl_compat and _tl_compat.ipairs or ipairs; local pairs = _tl_compat and _tl_compat.pairs or pairs; local string = _tl_compat and _tl_compat.string or string; local table = _tl_compat and _tl_compat.table or table; local _tl_table_unpack = unpack or table.unpack
local class = require("text-to-colorscheme.internal.class")
local GroupsProvider = require("text-to-colorscheme.internal.groups_provider")
local PaletteProvider = require("text-to-colorscheme.internal.palette_provider")
local HsvPalette = require("text-to-colorscheme.hsv_palette")
local UserSettings = require("text-to-colorscheme.user_settings")
local OpenAi = require("text-to-colorscheme.internal.openai")
local log = require("text-to-colorscheme.internal.log")
local default_settings_provider = require("text-to-colorscheme.internal.default_settings_provider")
local util = require("text-to-colorscheme.internal.util")
local color_util = require("text-to-colorscheme.internal.color_util")
local HsvColor = require("text-to-colorscheme.hsv_color")
local HexPalette = require("text-to-colorscheme.hex_palette")
local asserts = require("text-to-colorscheme.internal.asserts")

local null = {}

local ApiImpl = {}













function ApiImpl:__init()
   self._user_settings = default_settings_provider()
   self._groups_provider = GroupsProvider()
   self._palette_provider = PaletteProvider()
   self._open_ai = OpenAi()
   self._current_palette = null

   self._modified_palette = null
   self._modified_palette_saturation_offset = 0
   self._modified_palette_accent_order = { 1, 2, 3, 4, 5, 6, 7 }
   self._modified_palette_contrast = 1
end

function ApiImpl:change_settings(settings_overrides)
   log.verbose = settings_overrides.verbose_logs
   self._user_settings = vim.tbl_deep_extend("force", self._user_settings, settings_overrides or {})
   log.debug("Received call to setup()")
end

function ApiImpl:lazy_get_current_palette()
   if self._current_palette == null then
      asserts.that(self._user_settings.default_palette ~= nil, "default_palette is unset")
      self._current_palette = self._palette_provider:get_palette(self._user_settings.default_palette, self._user_settings, vim.o.background)
      asserts.that(self._modified_palette == null)
   end

   if self._modified_palette ~= null then
      return self._modified_palette
   end

   return self._current_palette
end

function ApiImpl:apply_current_palette()
   log.debug("Reloading color scheme...")

   local palette = self:lazy_get_current_palette()
   local groups, terminal_groups = self._groups_provider:get_highlight_groups(palette, self._user_settings, vim.o.background)

   if vim.g.colors_name then
      vim.cmd("hi clear")
   end

   vim.g.colors_name = "text-to-colorscheme"

   local update_count = 0
   for group, settings in pairs(groups) do
      vim.api.nvim_set_hl(0, group, settings)
      update_count = update_count + 1
   end

   asserts.that(#terminal_groups == 16)

   vim.g.terminal_color_0 = terminal_groups[1]
   vim.g.terminal_color_1 = terminal_groups[2]
   vim.g.terminal_color_2 = terminal_groups[3]
   vim.g.terminal_color_3 = terminal_groups[4]
   vim.g.terminal_color_4 = terminal_groups[5]
   vim.g.terminal_color_5 = terminal_groups[6]
   vim.g.terminal_color_6 = terminal_groups[7]
   vim.g.terminal_color_7 = terminal_groups[8]
   vim.g.terminal_color_8 = terminal_groups[9]
   vim.g.terminal_color_9 = terminal_groups[10]
   vim.g.terminal_color_10 = terminal_groups[11]
   vim.g.terminal_color_11 = terminal_groups[12]
   vim.g.terminal_color_12 = terminal_groups[13]
   vim.g.terminal_color_13 = terminal_groups[14]
   vim.g.terminal_color_14 = terminal_groups[15]
   vim.g.terminal_color_15 = terminal_groups[16]

   log.debug("Updated colors for %s highlight groups", update_count)
end

function ApiImpl:_reset_modified_palette()
   self._modified_palette = null
   self._modified_palette_saturation_offset = 0
   self._modified_palette_accent_order = { 1, 2, 3, 4, 5, 6, 7 }
   self._modified_palette_contrast = 1
end

function ApiImpl:reload_default()
   self._current_palette = null
   self:_reset_modified_palette()
   self:apply_current_palette()
end

function ApiImpl:set_current_palette(palette)
   self._current_palette = palette
   self:_reset_modified_palette()
end

function ApiImpl:_touch_up_generated_palette(palette)
   local min_fg_contrast = self._user_settings.minimum_generated_foreground_contrast



   local add_minimum_contrast = false

   local darken_greens = true

   local function adjust_foreground(fg)
      if add_minimum_contrast then
         local contrast = fg.v - palette.background.v

         if contrast < min_fg_contrast then
            fg = HsvColor(fg.h, fg.s, util.clamp(palette.background.v + min_fg_contrast, 0, 1))
         end
      end

      if darken_greens then


         local is_green = fg.h > 1 / 6 and fg.h < 1 / 2

         if is_green then
            fg = HsvColor(fg.h, fg.s, 0.85 * fg.v)
         end
      end

      return fg
   end

   asserts.that(#palette.accents == 7)

   return {
      name = palette.name,
      background_mode = palette.background_mode,
      background = palette.background,
      foreground = adjust_foreground(palette.foreground),
      accents = {
         adjust_foreground(palette.accents[1]),
         adjust_foreground(palette.accents[2]),
         adjust_foreground(palette.accents[3]),
         adjust_foreground(palette.accents[4]),
         adjust_foreground(palette.accents[5]),
         adjust_foreground(palette.accents[6]),
         adjust_foreground(palette.accents[7]),
      },
   }
end

function ApiImpl:lazy_generate_new_palette(theme_prompt, callback)
   asserts.that(theme_prompt ~= nil, "No theme provided to generate_new_palette method")

   log.info("Looking up existing theme for prompt '%s'", theme_prompt)
   local existing_palette = self._palette_provider:try_get_palette(theme_prompt, self._user_settings, vim.o.background)

   if existing_palette == nil then
      log.info("No existing theme for prompt '%s' found.  Generating new one...", theme_prompt)

      asserts.that(self._user_settings.openai_api_key ~= nil, "No OpenAI API key provided!  Please provide to text-to-colorscheme setup() method and try again")

      self._open_ai:generate_new_palette(theme_prompt, self._user_settings, function(openai_palette)
         log.info("Successfully received palette for theme '%s' from openai", theme_prompt)
         local hsv_palette = color_util.hex_palette_to_hsv_palette(openai_palette)
         hsv_palette = self:_touch_up_generated_palette(hsv_palette)
         callback(hsv_palette)
      end)
   else
      log.info("Successfully found existing theme for prompt '%s'", theme_prompt)
      callback(existing_palette)
   end
end

function ApiImpl:lazy_generate_new_palette_and_apply(theme_prompt)
   asserts.that(theme_prompt ~= nil, "No theme provided to generate_new_palette_and_apply method")

   self:lazy_generate_new_palette(theme_prompt, function(palette)
      self:set_current_palette(palette)
      self:apply_current_palette()
   end)
end

function ApiImpl:reset_changes()
   self:_reset_modified_palette()
   self:apply_current_palette()
end

function ApiImpl:_update_modified_palette()
   asserts.that(self._modified_palette_contrast >= 0)
   asserts.that(self._modified_palette_saturation_offset >= -1 and self._modified_palette_saturation_offset <= 1)
   asserts.that(#self._modified_palette_accent_order == 7)

   local palette = self._current_palette
   palette = color_util.add_contrast(palette, self._modified_palette_contrast)
   palette = color_util.offset_saturation(palette, self._modified_palette_saturation_offset)

   local new_accents = {}

   for _, index in ipairs(self._modified_palette_accent_order) do
      table.insert(new_accents, palette.accents[index])
   end

   palette.accents = new_accents

   self._modified_palette = palette

   self:apply_current_palette()
end

function ApiImpl:set_contrast(contrast)
   asserts.that(self._current_palette ~= null)
   if contrast < 0 then
      contrast = 0
   end
   self._modified_palette_contrast = contrast
   self:_update_modified_palette()
   log.notify("Contrast: %s", self._modified_palette_contrast)
end

function ApiImpl:add_contrast(contrast)
   self:set_contrast(self._modified_palette_contrast + contrast)
end

function ApiImpl:set_saturation_offset(offset)
   asserts.that(self._current_palette ~= null)
   self._modified_palette_saturation_offset = util.clamp(offset, -1, 1)
   self:_update_modified_palette()
   log.notify("Saturation Offset: %s", self._modified_palette_saturation_offset)
end

function ApiImpl:add_saturation_offset(offset)
   self:set_saturation_offset(self._modified_palette_saturation_offset + offset)
end

function ApiImpl:shuffle_accents()
   asserts.that(self._current_palette ~= null)
   self._modified_palette_accent_order = util.shuffle({ 1, 2, 3, 4, 5, 6, 7 })
   self:_update_modified_palette()
end

function ApiImpl:_add_save_popup_highlights(buf, palette)
   local highlight_matches = {}
   vim.api.nvim_command('highlight T2CSavePopupBackground guifg=#ffffff guibg=' .. palette.background)
   table.insert(highlight_matches, { palette.background, "T2CSavePopupBackground" })
   vim.api.nvim_command('highlight T2CSavePopupForeground guifg=' .. palette.foreground .. ' guibg=' .. palette.background)
   table.insert(highlight_matches, { palette.foreground, "T2CSavePopupBackground" })
   for index, value in ipairs(palette.accents) do
      local highlight_name = 'T2CSavePopupAccent' .. tostring(index)
      vim.api.nvim_command('highlight ' .. highlight_name .. ' guifg=' .. value .. ' guibg=' .. palette.background)
      table.insert(highlight_matches, { value, highlight_name })
   end

   local ns_id = vim.api.nvim_create_namespace('T2CSavePopupHighlights')
   local line_count = vim.api.nvim_buf_line_count(buf)

   for i = 0, line_count - 1 do
      local line = vim.api.nvim_buf_get_lines(buf, i, i + 1, false)[1]

      for _, pair in ipairs(highlight_matches) do
         local text, highlight_group = _tl_table_unpack(pair)

         if line:find(text) ~= nil then
            local non_whitespace_start = line:find("%S")
            if non_whitespace_start then
               vim.api.nvim_buf_add_highlight(buf, ns_id, highlight_group, i, non_whitespace_start - 1, #line)
               break
            end
         end
      end
   end
end

function ApiImpl:user_save_current_palette()
   local function create_scratch_buffer()
      local buf = vim.api.nvim_create_buf(false, true)

      vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
      vim.api.nvim_buf_set_option(buf, 'bufhidden', 'hide')
      vim.api.nvim_buf_set_option(buf, 'swapfile', false)

      return buf
   end

   local text = [[
-- To save the current theme persistently, copy the following into
-- the call you're making to require("text-to-colorscheme").setup()

]]

   local custom_hsv_to_str

   if self._user_settings.save_as_hsv then
      custom_hsv_to_str = function(hsv)
         local hsv_int = color_util.hsv_to_hsv_int(hsv)
         return string.format("{%s, %s, %s}, -- %s\n", hsv_int[1], hsv_int[2], hsv_int[3], color_util.hsv_to_hex(hsv))
      end
      text = text .. "\nhsv_palettes = "
   else
      custom_hsv_to_str = function(hsv)
         return string.format("\"%s\",\n", color_util.hsv_to_hex(hsv))
      end
      text = text .. "\nhex_palettes = "
   end

   local palette = self:lazy_get_current_palette()

   text = text .. [[{
   {
      name = "]] .. palette.name .. [[",
      background_mode = "]] .. palette.background_mode .. [[",
      background = ]] .. custom_hsv_to_str(palette.background) .. [[
      foreground = ]] .. custom_hsv_to_str(palette.foreground) .. [[
      accents = {
         ]] .. custom_hsv_to_str(palette.accents[1]) .. [[
         ]] .. custom_hsv_to_str(palette.accents[2]) .. [[
         ]] .. custom_hsv_to_str(palette.accents[3]) .. [[
         ]] .. custom_hsv_to_str(palette.accents[4]) .. [[
         ]] .. custom_hsv_to_str(palette.accents[5]) .. [[
         ]] .. custom_hsv_to_str(palette.accents[6]) .. [[
         ]] .. custom_hsv_to_str(palette.accents[7]) .. [[
      }
   }
}
]]
   local contents = vim.tbl_flatten(util.split(text, "\n"))

   local buf = create_scratch_buffer()
   vim.api.nvim_buf_set_lines(buf, 0, -1, false, contents)

   local win_width = 80
   local win_height = 20


   local editor_width = vim.api.nvim_get_option("columns")
   local editor_height = vim.api.nvim_get_option("lines")
   local col = (editor_width - win_width) / 2
   local row = (editor_height - win_height) / 2

   vim.api.nvim_open_win(buf, true, {
      relative = 'editor',
      width = win_width,
      height = win_height,
      col = col,
      row = row,
   })

   self:_add_save_popup_highlights(buf, color_util.hsv_palette_to_hex_palette(palette))

   local cmd = string.format('autocmd WinLeave <buffer=%s> :bwipeout!', buf)
   vim.api.nvim_command('augroup MyCloseScratch')
   vim.api.nvim_command('autocmd!')
   vim.api.nvim_command(cmd)
   vim.api.nvim_command('augroup END')

   vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':bwipeout!<CR>', { noremap = true, silent = true })
end

class.setup(ApiImpl, "ApiImpl")
return ApiImpl
