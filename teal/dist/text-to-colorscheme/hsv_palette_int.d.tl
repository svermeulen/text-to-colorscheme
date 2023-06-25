
local record HsvPaletteInt
   name:string
   background_mode:vim.BackgroundMode
   background:{integer, integer, integer}
   foreground:{integer, integer, integer}
   accents:{{integer, integer, integer}}
end

return HsvPaletteInt
