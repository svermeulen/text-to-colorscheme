
local HsvPaletteInt = require("text-to-colorscheme.hsv_palette_int")



return function()
   return {
      {
         name = "dracula",
         background_mode = "dark",
         background = { 231, 26, 21 },
         foreground = { 60, 2, 80 },
         accents = {
            { 326, 53, 80 },
            { 191, 45, 80 },
            { 65, 44, 68 },
            { 265, 41, 80 },
            { 31, 58, 80 },
            { 135, 68, 68 },
            { 0, 57, 80 },
         },
      },
      {
         name = "urban autumn",
         background_mode = "dark",
         background = { 0, 0, 15 },
         foreground = { 48, 21, 100 },
         accents = {
            { 27, 90, 100 },
            { 344, 36, 100 },
            { 42, 81, 100 },
            { 61, 80, 85 },
            { 157, 21, 85 },
            { 104, 35, 85 },
            { 6, 79, 100 },
         },
      },
      {
         name = "cosmic orchard",
         background_mode = "dark",
         background = { 220, 23, 20 },
         foreground = { 219, 10, 85 },
         accents = {
            { 286, 46, 87 },
            { 95, 38, 87 },
            { 29, 51, 87 },
            { 187, 56, 87 },
            { 207, 59, 87 },
            { 39, 46, 87 },
            { 355, 56, 87 },
         },
      },
      {
         name = "aurora dreams",
         background_mode = "dark",
         background = { 192, 100, 21 },
         foreground = { 197, 23, 82 },
         accents = {
            { 175, 74, 70 },
            { 205, 82, 82 },
            { 45, 100, 82 },
            { 237, 45, 82 },
            { 331, 74, 82 },
            { 18, 89, 82 },
            { 1, 79, 82 },
         },
      },
      {
         name = "oceanic aurora",
         background_mode = "dark",
         background = { 202, 48, 20 },
         foreground = { 219, 7, 85 },
         accents = {
            { 300, 25, 87 },
            { 114, 26, 87 },
            { 40, 60, 87 },
            { 219, 58, 87 },
            { 167, 30, 87 },
            { 21, 65, 87 },
            { 357, 60, 87 },
         },
      },
   }
end
