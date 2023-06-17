
local UserSettings = require("text-to-colorscheme.user_settings")

return function()
   return {
      undercurl = true,
      underline = true,
      ai = {
         gpt_model = "gpt-4",
         openai_api_key = nil,
         auto_darken_greens = true,
         green_darkening_amount = 0.85,
         minimum_foreground_contrast = 0.4,
         enable_minimum_foreground_contrast = true,
      },
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
      default_palette = "gruvbox",
   }
end
