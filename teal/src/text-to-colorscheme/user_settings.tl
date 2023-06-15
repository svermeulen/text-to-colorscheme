
local HexPalette <const> = require("text-to-colorscheme.hex_palette")
local HsvPaletteInt <const> = require("text-to-colorscheme.hsv_palette_int")

local record UserSettings
   enum GptModel
      "gpt-3.5-turbo"
      "gpt-4"
   end

   record ItalicSettings
      strings:boolean
      comments:boolean
      operators:boolean
      folds:boolean
   end

   record AiSettings
      gpt_model:GptModel
      openai_api_key:string
      auto_darken_greens:boolean
      green_darkening_amount:number
      minimum_foreground_contrast:number
      enable_minimum_foreground_contrast:boolean
   end

   save_as_hsv:boolean

   undercurl:boolean
   underline:boolean
   bold:boolean
   italic:ItalicSettings
   strikethrough:boolean
   invert_selection:boolean
   invert_signs:boolean
   invert_tabline:boolean
   invert_intend_guides:boolean
   inverse:boolean
   dim_inactive:boolean
   transparent_mode:boolean
   overrides:{string:vim.HighlightDefinition}
   hex_palettes:{HexPalette}
   hsv_palettes:{HsvPaletteInt}
   default_palette:string
   verbose_logs:boolean
   ai:AiSettings
end

return UserSettings
