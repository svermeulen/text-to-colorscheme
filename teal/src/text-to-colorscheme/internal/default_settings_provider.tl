
local UserSettings <const> = require("text-to-colorscheme.user_settings")

return function():UserSettings
   return {
      undercurl = true,
      underline = true,
      gpt_model = "gpt-4",
      openai_api_key = nil,
      verbose_logs = false,
      bold = true,
      italic = {
         strings = true,
         comments = true,
         operators = false,
         folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      save_as_hsv = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true,
      dim_inactive = false,
      transparent_mode = false,
      hsv_palettes = {},
      hex_palettes = {},
      overrides = {},
      default_palette = "urban autumn",
   }
end
