
local HsvColor <const> = require("text-to-colorscheme.hsv_color")

local record CustomHighlightDefinition
   fg:HsvColor
   bg:HsvColor
   sp:HsvColor
   underline: boolean
   italic: boolean
   reverse: boolean
   bold: boolean
   strikethrough: boolean
   link: string
   undercurl: boolean
end

return CustomHighlightDefinition
