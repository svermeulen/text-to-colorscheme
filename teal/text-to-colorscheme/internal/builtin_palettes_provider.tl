
local HsvPaletteInt <const> = require("text-to-colorscheme.hsv_palette_int")

-- Note here that we use descriptive names instead of their original names
-- because we also use these as examples for chat gpt to extrapolate from
return function():{HsvPaletteInt}
   return { 
      {
         name = "dracula",
         background_mode = "dark",
         background = {231, 26, 21}, -- #282a36
         foreground = {60, 2, 80}, -- #cbcbc7
         accents = {
            {326, 53, 80}, -- #cb609d
            {191, 45, 80}, -- #70bbcb
            {65, 44, 68}, -- #a7ad61
            {265, 41, 80}, -- #9b78cb
            {31, 58, 80}, -- #cb9255
            {135, 68, 68}, -- #37ad55
            {0, 57, 80}, -- #cb5858
         }
      },
      {
        name = "urban autumn", -- aka gruvbox
        background_mode = "dark",
        background = {0, 0, 15}, -- #272727
        foreground = {48, 21, 100}, -- #fff4c9
        accents = {
           {27, 90, 100}, -- #ff8119
           {344, 36, 100}, -- #ffa3bc
           {42, 81, 100}, -- #ffc130
           {61, 80, 85}, -- #d6d92b
           {157, 21, 85}, -- #abd9c7
           {104, 35, 85}, -- #a1d98d
           {6, 79, 100}, -- #ff4a36
        }
      },
      {
         name = "cosmic orchard", -- aka onedark
         background_mode = "dark",
         background = {220, 23, 20}, -- #272b33
         foreground = {219, 10, 85}, -- #c3cbd9
         accents = {
            {286, 46, 87}, -- #c678de
            {95, 38, 87}, -- #adde8a
            {29, 51, 87}, -- #dea36d
            {187, 56, 87}, -- #62cfde
            {207, 59, 87}, -- #5ba3de
            {39, 46, 87}, -- #deba78
            {355, 56, 87}, -- #de626c
         }
      },
      {
         name = "aurora dreams", -- aka solarized
         background_mode = "dark",
         background = {192, 100, 21}, -- #002a35
         foreground = {197, 23, 82}, -- #a2c4d2
         accents = {
            {175, 74, 70}, -- #2eb3a8
            {205, 82, 82}, -- #268ad2
            {45, 100, 82}, -- #d29e00
            {237, 45, 82}, -- #7478d2
            {331, 74, 82}, -- #d23782
            {18, 89, 82}, -- #d24f17
            {1, 79, 82}, -- #d22f2c
         }
      },
      {
         name = "oceanic aurora", -- aka OceanicNext
         background_mode = "dark",
         background = {202, 48, 20}, -- #1b2a33
         foreground = {219, 7, 85}, -- #cacfd9
         accents = {
            {300, 25, 87}, -- #dea6de
            {114, 26, 87}, -- #aadea4
            {40, 60, 87}, -- #deb159
            {219, 58, 87}, -- #5d8ade
            {167, 30, 87}, -- #9bdecf
            {21, 65, 87}, -- #de804e
            {357, 60, 87}, -- #de595f
         }
      },
   }
end
