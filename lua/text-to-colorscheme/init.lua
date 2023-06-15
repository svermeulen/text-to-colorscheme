
local ApiImpl = require("text-to-colorscheme.internal.api_impl")
local UserSettings = require("text-to-colorscheme.user_settings")
local HsvPalette = require("text-to-colorscheme.hsv_palette")

local _impl

local api = {}


local function lazy_init()
   if _impl ~= nil then
      return true
   end

   if vim.version().minor < 8 then
      vim.api.nvim_err_writeln("[text-to-colorscheme] This plugin requires neovim 0.8 or higher")
      return false
   end

   _impl = ApiImpl()
   return true
end

function api.setup(settings_overrides)
   if not lazy_init() then
      return
   end

   _impl:change_settings(settings_overrides)
end

function api.get_palette()
   if not lazy_init() then
      return
   end

   return _impl:lazy_get_current_palette()
end

function api.load()
   if not lazy_init() then
      return
   end

   _impl:reload_default()
end

function api.set_palette(palette)
   if not lazy_init() then
      return
   end

   _impl:set_current_palette(palette)
   _impl:apply_current_palette()
end

function api.set_contrast(contrast)
   if not lazy_init() then
      return
   end

   _impl:set_contrast(contrast)
end

function api.add_contrast(offset)
   if not lazy_init() then
      return
   end

   _impl:add_contrast(offset)
end

function api.set_saturation_offset(offset)
   if not lazy_init() then
      return
   end

   _impl:set_saturation_offset(offset)
end

function api.add_saturation_offset(offset)
   if not lazy_init() then
      return
   end

   _impl:add_saturation_offset(offset)
end

function api.user_save_current_palette()
   if not lazy_init() then
      return
   end

   _impl:user_save_current_palette()
end

function api.generate_new_palette(theme_prompt, callback)
   if not lazy_init() then
      return
   end

   _impl:lazy_generate_new_palette(theme_prompt, callback)
end

function api.generate_new_palette_and_apply(theme_prompt)
   if not lazy_init() then
      return
   end

   _impl:lazy_generate_new_palette_and_apply(theme_prompt)
end

function api.shuffle_accents()
   if not lazy_init() then
      return
   end

   _impl:shuffle_accents()
end

return api
