
local ApiImpl <const> = require("text-to-colorscheme.internal.api_impl")
local UserSettings <const> = require("text-to-colorscheme.user_settings")
local HsvPalette <const> = require("text-to-colorscheme.hsv_palette")

local _impl:ApiImpl

local record api
end

local function lazy_init():boolean
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

local function trigger_reload()
   vim.cmd("colo text-to-colorscheme")
end

function api.setup(settings_overrides:UserSettings)
   if not lazy_init() then
      return
   end

   _impl:change_settings(settings_overrides)
end

function api.get_palette():HsvPalette
   if not lazy_init() then
      return
   end

   return _impl:lazy_get_current_palette()
end

function api.get_all_palette_names():{string}
   if not lazy_init() then
      return
   end

   return _impl:get_all_palette_names()
end

function api.load()
   if not lazy_init() then
      return
   end

   _impl:apply_current_palette()
end

function api.load_default()
   if not lazy_init() then
      return
   end

   _impl:reset_to_default()
   trigger_reload()
end

function api.set_palette(palette:HsvPalette)
   if not lazy_init() then
      return
   end

   _impl:set_current_palette(palette)
   trigger_reload()
end

function api.set_contrast(contrast:number)
   if not lazy_init() then
      return
   end

   _impl:set_contrast(contrast)
   trigger_reload()
end

function api.add_contrast(offset:number)
   if not lazy_init() then
      return
   end

   _impl:add_contrast(offset)
   trigger_reload()
end

function api.set_saturation_offset(offset:number)
   if not lazy_init() then
      return
   end

   _impl:set_saturation_offset(offset)
   trigger_reload()
end

function api.add_saturation_offset(offset:number)
   if not lazy_init() then
      return
   end

   _impl:add_saturation_offset(offset)
   trigger_reload()
end

function api.user_save_current_palette()
   if not lazy_init() then
      return
   end

   _impl:user_save_current_palette()
end

function api.generate_new_palette(theme_prompt:string, callback:function(HsvPalette))
   if not lazy_init() then
      return
   end

   _impl:generate_new_palette(theme_prompt, callback)
end

function api.select_palette(name:string)
   if not lazy_init() then
      return
   end

   _impl:select_palette(name)
   trigger_reload()
end

function api.generate_new_palette_and_apply(theme_prompt:string)
   if not lazy_init() then
      return
   end

   _impl:generate_new_palette(theme_prompt, function(palette:HsvPalette)
      _impl:set_current_palette(palette)
      trigger_reload()
   end)
end

function api.reset_changes()
   if not lazy_init() then
      return
   end

   _impl:reset_changes()
   trigger_reload()
end

function api.shuffle_accents()
   if not lazy_init() then
      return
   end

   _impl:shuffle_accents()
   trigger_reload()
end

return api
