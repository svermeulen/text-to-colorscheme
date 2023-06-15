
local HsvPaletteInt <const> = require("text-to-colorscheme.hsv_palette_int")

-- Note here that we use descriptive names instead of their original names
-- because we also use these as examples for chat gpt to extrapolate from
return function():{HsvPaletteInt}
   return { 
      {
         name = "urban autumn", -- aka gruvbox
         background_mode = "dark",
         background = {0, 0, 15}, -- #262626
         foreground = {48, 21, 100}, -- #fff4c9
         accents = {
            {27, 90, 98}, -- #fa7e19
            {344, 36, 95}, -- #f29bb2
            {42, 81, 97}, -- #f7bb2f
            {61, 80, 85}, -- #d6d92b
            {157, 21, 88}, -- #b1e0ce
            {104, 35, 85}, -- #a1d98d
            {6, 79, 99}, -- #fc4935
         }
      },
      {
         name = "cosmic orchard",
         background_mode = "dark",
         background = {220, 23, 20}, -- #282c34
         foreground = {219, 10, 75}, -- #abb2bf
         accents = {
            {286, 46, 87}, -- #c678dd
            {95, 38, 76}, -- #98c379
            {29, 51, 82}, -- #d19a66
            {187, 56, 76}, -- #56b6c2
            {207, 59, 94}, -- #61afef
            {39, 46, 90}, -- #e5c07b
            {355, 56, 91}, -- #e86671
         }
      },
      {
         name = "dracula",
         background_mode = "dark",
         background = {231, 26, 17}, -- #20222b
         foreground = {60, 2, 97}, -- #f7f7f2
         accents = {
            {326, 53, 100}, -- #ff78c4
            {191, 45, 99}, -- #8be8fc
            {137, 59, 98}, -- #66fa90
            {270, 33, 97}, -- #cfa6f7
            {65, 44, 98}, -- #f1fa8c
            {135, 68, 99}, -- #51fc7c
            {0, 57, 100}, -- #ff6e6e
         }
      },
      {
         name = "aurora dreams",
         background_mode = "dark",
         background = {192, 89, 24}, -- #06323d
         foreground = {186, 13, 67}, -- #94a7aa
         accents = {
            {175, 74, 72}, -- #30b8ae
            {205, 82, 97}, -- #2da4f8
            {18, 89, 94}, -- #ef581a
            {237, 45, 90}, -- #7e84e6
            {331, 74, 98}, -- #f94099
            {68, 100, 68}, -- #97ae00
            {1, 79, 100}, -- #ff3a36
         }
      },
      {
         name = "oceanic aurora", -- aka OceanicNext
         background_mode = "dark",
         background = {202, 48, 20}, -- #1b2b34
         foreground = {219, 7, 91}, -- #d8dee9
         accents = {
            {300, 25, 77}, -- #c594c5
            {114, 26, 78}, -- #99c794
            {40, 60, 98}, -- #fac863
            {210, 50, 80}, -- #6699cc
            {179, 45, 70}, -- #62b3b2
            {21, 65, 98}, -- #f99157
            {357, 60, 93}, -- #ec5f67
         }
      },
   }
end
