
local ApiImpl <const> = require("text-to-colorscheme.internal.api_impl")
local UserSettings <const> = require("text-to-colorscheme.user_settings")
local HsvPalette <const> = require("text-to-colorscheme.hsv_palette")
local asserts <const> = require("text-to-colorscheme.internal.asserts")

local _impl:ApiImpl

local record api
end

function api.setup(settings_overrides:UserSettings)
   if vim.version().minor < 8 then
      vim.api.nvim_err_writeln("[text-to-colorscheme] This plugin requires neovim 0.8 or higher")
      return
   end

   if _impl == nil then
      _impl = ApiImpl()
   end

   _impl:setup(settings_overrides)
end

local function ensure_initialized()
   asserts.that(_impl ~= nil, "[text-to-colorscheme] Must call setup() first before other api methods")
end

function api.get_palette():HsvPalette
   ensure_initialized()
   return _impl:lazy_get_current_palette()
end

function api.load()
   ensure_initialized()
   _impl:reload_default()
end

function api.set_palette(palette:HsvPalette)
   ensure_initialized()
   _impl:set_current_palette(palette)
   _impl:apply_current_palette()
end

function api.set_contrast(contrast:number)
   ensure_initialized()
   _impl:set_contrast(contrast)
end

function api.add_contrast(offset:number)
   ensure_initialized()
   _impl:add_contrast(offset)
end

function api.set_saturation_offset(offset:number)
   ensure_initialized()
   _impl:set_saturation_offset(offset)
end

function api.add_saturation_offset(offset:number)
   ensure_initialized()
   _impl:add_saturation_offset(offset)
end

function api.user_save_current_palette()
   asserts.that(_impl ~= nil, "[text-to-colorscheme] Must call setup() first before other api methods")
   _impl:user_save_current_palette()
end

function api.generate_new_palette(theme_prompt:string, callback:function(HsvPalette))
   asserts.that(_impl ~= nil, "[text-to-colorscheme] Must call setup() first before other api methods")
   _impl:generate_new_palette(theme_prompt, callback)
end

function api.generate_new_palette_and_apply(theme_prompt:string)
   asserts.that(_impl ~= nil, "[text-to-colorscheme] Must call setup() first before other api methods")
   asserts.that(theme_prompt ~= nil, "No theme provided to generate_new_palette_and_apply method")

   _impl:generate_new_palette(theme_prompt, function(palette:HsvPalette)
      _impl:set_current_palette(palette)
      _impl:apply_current_palette()
   end)
end

return api
