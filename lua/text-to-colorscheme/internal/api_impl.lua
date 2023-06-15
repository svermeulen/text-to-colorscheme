local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local pairs = _tl_compat and _tl_compat.pairs or pairs; local string = _tl_compat and _tl_compat.string or string
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
end

function ApiImpl:setup(settings_overrides)
   log.verbose = settings_overrides.verbose_logs
   self._user_settings = vim.tbl_deep_extend("force", self._user_settings, settings_overrides or {})
   log.debug("Received call to setup()")
end

function ApiImpl:lazy_get_current_palette()
   if self._current_palette == null then
      self._current_palette = self._palette_provider:get_default(self._user_settings, vim.o.background)
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

function ApiImpl:reload_default()
   self._current_palette = null
   self:apply_current_palette()
end

function ApiImpl:set_current_palette(palette)
   self._current_palette = palette
end

function ApiImpl:generate_new_palette(api_key, theme_prompt, callback)
   self._open_ai:generate_new_palette(api_key, theme_prompt, self._user_settings, function(openai_palette)
      log.info("Successfully received palette for theme '%s' from openai", theme_prompt)
      callback(color_util.hex_palette_to_hsv_palette(openai_palette))
   end)
end

function ApiImpl:user_save_current_palette()
   local palette = self._current_palette

   if palette == nil then
      log.error("Could not find any palette set")
      return
   end

   local function create_scratch_buffer()
      local buf = vim.api.nvim_create_buf(false, true)

      vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
      vim.api.nvim_buf_set_option(buf, 'bufhidden', 'hide')
      vim.api.nvim_buf_set_option(buf, 'swapfile', false)

      return buf
   end

   local text = [[
-- To save the current theme persistently, copy the following entry to custom_palettes
-- into the call you're making to require("text-to-colorscheme").setup()

]]

   local custom_hsv_to_str

   if self._user_settings.save_as_hsv then
      custom_hsv_to_str = function(hsv)
         local hsv_int = color_util.hsv_to_hsv_int(hsv)
         return string.format("{%s, %s, %s}, -- %s\n", hsv_int[1], hsv_int[2], hsv_int[3], color_util.hsv_to_hex(hsv))
      end
   else
      custom_hsv_to_str = function(hsv)
         return string.format("\"%s\",\n", color_util.hsv_to_hex(hsv))
      end
   end

   text = text .. [[
hsv_palettes = {
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
},
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

   local cmd = string.format('autocmd WinLeave <buffer=%s> :bwipeout!', buf)
   vim.api.nvim_command('augroup MyCloseScratch')
   vim.api.nvim_command('autocmd!')
   vim.api.nvim_command(cmd)
   vim.api.nvim_command('augroup END')

   vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':bwipeout!<CR>', { noremap = true, silent = true })
end

class.setup(ApiImpl, "ApiImpl")
return ApiImpl
