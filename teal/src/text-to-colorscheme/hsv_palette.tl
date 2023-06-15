
local HsvColor <const> = require("text-to-colorscheme.hsv_color")

local record HsvPalette
   name:string
   background_mode:vim.BackgroundMode
   background:HsvColor
   foreground:HsvColor
   accents:{HsvColor}
end

return HsvPalette
