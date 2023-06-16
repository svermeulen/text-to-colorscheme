
local HsvPaletteInt = require("text-to-colorscheme.hsv_palette_int")

return function()
   return {
      {
         name = "gruvbox",
         background_mode = "dark",
         background = { 0, 0, 15 },
         foreground = { 48, 21, 100 },
         accents = {
            { 27, 90, 98 },
            { 344, 36, 95 },
            { 42, 81, 97 },
            { 61, 80, 85 },
            { 157, 21, 88 },
            { 104, 35, 85 },
            { 6, 79, 99 },
         },
      },
      {
         name = "onedark",
         background_mode = "dark",
         background = { 220, 23, 20 },
         foreground = { 219, 10, 75 },
         accents = {
            { 286, 46, 87 },
            { 95, 38, 76 },
            { 29, 51, 82 },
            { 187, 56, 76 },
            { 207, 59, 94 },
            { 39, 46, 90 },
            { 355, 56, 91 },
         },
      },
      {
         name = "dracula",
         background_mode = "dark",
         background = { 231, 26, 17 },
         foreground = { 60, 2, 97 },
         accents = {
            { 326, 53, 100 },
            { 191, 45, 99 },
            { 137, 59, 98 },
            { 270, 33, 97 },
            { 65, 44, 98 },
            { 135, 68, 99 },
            { 0, 57, 100 },
         },
      },
      {
         name = "solarized",
         background_mode = "dark",
         background = { 192, 89, 24 },
         foreground = { 186, 13, 67 },
         accents = {
            { 175, 74, 72 },
            { 205, 82, 97 },
            { 18, 89, 94 },
            { 237, 45, 90 },
            { 331, 74, 98 },
            { 68, 100, 68 },
            { 1, 79, 100 },
         },
      },
      {
         name = "OceanicNext",
         background_mode = "dark",
         background = { 202, 48, 20 },
         foreground = { 219, 7, 91 },
         accents = {
            { 300, 25, 77 },
            { 114, 26, 78 },
            { 40, 60, 98 },
            { 210, 50, 80 },
            { 179, 45, 70 },
            { 21, 65, 98 },
            { 357, 60, 93 },
         },
      },
   }
end
