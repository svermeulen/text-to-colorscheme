local class <const> = require("text-to-colorscheme.internal.class")
local HexPalette <const> = require("text-to-colorscheme.hex_palette")
local HsvPalette <const> = require("text-to-colorscheme.hsv_palette")
local UserSettings <const> = require("text-to-colorscheme.user_settings")
local asserts <const> = require("text-to-colorscheme.internal.asserts")
local log <const> = require("text-to-colorscheme.internal.log")
local color_util <const> = require("text-to-colorscheme.internal.color_util")
local HsvPaletteInt <const> = require("text-to-colorscheme.hsv_palette_int")
local builtin_palettes_provider <const> = require("text-to-colorscheme.internal.builtin_palettes_provider")

local record PaletteProvider
   _builtin_palettes:{string:HsvPalette}
   metamethod __call: function(self: PaletteProvider): PaletteProvider
end

local function create_builtin_hsv_palettes():{string:HsvPalette}
   local result = {}
   local hsv_palettes = builtin_palettes_provider()

   for _, value in ipairs(hsv_palettes) do
      result[value.name] = color_util.hsv_palette_int_to_hsv_palette(value)
   end

   return result
end

function PaletteProvider:__init()
   self._builtin_palettes = create_builtin_hsv_palettes()
end

function PaletteProvider:get_all_palette_names(user_settings:UserSettings):{string}
   local names = {}

   if not user_settings.disable_builtin_schemes then
      for name, _ in pairs(self._builtin_palettes) do
         table.insert(names, name)
      end
   end

   for _, palette in ipairs(user_settings.hex_palettes) do
      table.insert(names, palette.name)
   end

   for _, palette in ipairs(user_settings.hsv_palettes) do
      table.insert(names, palette.name)
   end

   return names
end

local function is_valid_user_hsv_palette(palette:HsvPaletteInt):boolean
   if palette.background == nil or palette.foreground == nil or palette.accents == nil or palette.background_mode == nil or palette.name == nil then
      return false
   end

   if not color_util.is_valid_hsv_color_int(table.unpack(palette.background)) or not color_util.is_valid_hsv_color_int(table.unpack(palette.foreground)) then
      return false
   end

   if #palette.accents ~= 7 then
      return false
   end

   for _, value in ipairs(palette.accents) do
      if not color_util.is_valid_hsv_color_int(table.unpack(value)) then
         return false
      end
   end

   return true
end

local function is_valid_user_hex_palette(palette:HexPalette):boolean
   if palette.background == nil or palette.foreground == nil or palette.accents == nil or palette.background_mode == nil or palette.name == nil then
      return false
   end

   if not color_util.is_valid_hex_color(palette.background) or not color_util.is_valid_hex_color(palette.foreground) then
      return false
   end

   if #palette.accents ~= 7 then
      return false
   end

   for _, value in ipairs(palette.accents) do
      if not color_util.is_valid_hex_color(value) then
         return false
      end
   end

   return true
end

function PaletteProvider:_try_get_user_palette(name:string, user_settings:UserSettings, background_mode:vim.BackgroundMode):HsvPalette
   for _, palette in ipairs(user_settings.hex_palettes) do
      if palette.name == name and palette.background_mode == background_mode then

         if not is_valid_user_hex_palette(palette) then
            log.error("Invalid values provided for palette '%s'", name)
            return nil
         end

         return color_util.hex_palette_to_hsv_palette(palette)
      end
   end

   for _, palette in ipairs(user_settings.hsv_palettes) do
      if palette.name == name and palette.background_mode == background_mode then

         if not is_valid_user_hsv_palette(palette) then
            log.error("Invalid values provided for palette '%s'", name)
            return nil
         end

         return color_util.hsv_palette_int_to_hsv_palette(palette)
      end
   end

   return nil
end

function PaletteProvider:try_get_palette(name:string, user_settings:UserSettings, background_mode:vim.BackgroundMode):HsvPalette
   local palette:HsvPalette = self:_try_get_user_palette(name, user_settings, background_mode)

   if palette == nil then
      palette = self._builtin_palettes[name]
   end

   return palette
end

function PaletteProvider:get_palette(name:string, user_settings:UserSettings, background_mode:vim.BackgroundMode):HsvPalette
   local palette = self:try_get_palette(name, user_settings, background_mode)
   asserts.that(palette ~= nil, "Could not find any palette with name '%s'", name)
   return palette
end

class.setup(PaletteProvider, "PaletteProvider")
return PaletteProvider
