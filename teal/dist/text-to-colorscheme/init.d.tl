
local UserSettings <const> = require("text-to-colorscheme.user_settings")
local HsvPalette <const> = require("text-to-colorscheme.hsv_palette")

local record Api
   setup:function(settings_overrides:UserSettings)
   get_palette:function():HsvPalette
   get_all_palette_names:function():{string}
   load:function()
   load_default:function()
   set_palette:function(palette:HsvPalette)
   set_contrast:function(contrast:number)
   add_contrast:function(offset:number)
   set_saturation_offset:function(offset:number)
   add_saturation_offset:function(offset:number)
   user_save_current_palette:function()
   generate_new_palette:function(theme_prompt:string, callback:function(HsvPalette))
   select_palette:function(name:string)
   generate_new_palette_and_apply:function(theme_prompt:string)
   reset_changes:function()
   shuffle_accents:function()
end

return Api
