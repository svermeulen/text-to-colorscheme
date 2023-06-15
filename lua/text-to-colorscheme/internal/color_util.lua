local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local ipairs = _tl_compat and _tl_compat.ipairs or ipairs; local math = _tl_compat and _tl_compat.math or math; local string = _tl_compat and _tl_compat.string or string; local table = _tl_compat and _tl_compat.table or table
local class = require("text-to-colorscheme.internal.class")
local asserts = require("text-to-colorscheme.internal.asserts")
local util = require("text-to-colorscheme.internal.util")
local RgbColor = require("text-to-colorscheme.internal.rgb_color")
local RgbColorInt = require("text-to-colorscheme.internal.rgb_color_int")
local HsvColor = require("text-to-colorscheme.hsv_color")
local HexPalette = require("text-to-colorscheme.hex_palette")
local HsvPalette = require("text-to-colorscheme.hsv_palette")
local HsvPaletteInt = require("text-to-colorscheme.hsv_palette_int")

local color_util = {}


function color_util.__init()
end

function color_util.hex_to_rgb(hex)
   asserts.that(util.starts_with(hex, "#"), "Expected to find hex color but instead found '%s'", hex)

   local hex_numbers = hex:sub(2)

   local function hex_value_to_number(value)
      return tonumber("0x" .. value)
   end

   return RgbColor(
   hex_value_to_number(hex_numbers:sub(1, 2)) / 255,
   hex_value_to_number(hex_numbers:sub(3, 4)) / 255,
   hex_value_to_number(hex_numbers:sub(5, 6)) / 255)

end

function color_util.is_valid_hsv_color_int(h, s, v)
   return h >= 0 and h <= 360 and s >= 0 and s <= 100 and v >= 0 and v <= 100
end

function color_util.is_valid_hex_color(value)
   return string.match(value, '^#[%da-fA-F][%da-fA-F][%da-fA-F][%da-fA-F][%da-fA-F][%da-fA-F]$') ~= nil
end

function color_util.rgb_to_rgb_int(rgb)
   local function to_integer(value)
      asserts.that(value >= 0 and value <= 1)
      return math.floor(value * 255 + 0.5)
   end

   return RgbColorInt(to_integer(rgb.r), to_integer(rgb.g), to_integer(rgb.b))
end

function color_util.rgb_to_hex(rgb)
   local rbg_int = color_util.rgb_to_rgb_int(rgb)
   return string.format("#%02x%02x%02x", rbg_int.r, rbg_int.g, rbg_int.b)
end

function color_util.rgb_to_hsv(rgb)
   local r, g, b = rgb.r, rgb.g, rgb.b

   local max, min = math.max(r, g, b), math.min(r, g, b)
   local h
   local s
   local v
   v = max

   local delta = max - min
   if max == 0 then
      s = 0
   else
      s = delta / max
   end

   if max == min then
      h = 0
   else
      if max == r then
         h = (g - b) / delta
         if g < b then
            h = h + 6
         end
      elseif max == g then
         h = (b - r) / delta + 2
      elseif max == b then
         h = (r - g) / delta + 4
      end
      h = h / 6
   end

   asserts.that(h >= 0 and h <= 1)
   asserts.that(s >= 0 and s <= 1)
   asserts.that(v >= 0 and v <= 1)

   return HsvColor(h, s, v)
end

function color_util.hex_to_hsv(hex)
   return color_util.rgb_to_hsv(color_util.hex_to_rgb(hex))
end

function color_util.hsv_to_rgb(hsv)
   local r, g, b = 0.0, 0.0, 0.0

   local h = hsv.h
   local s = hsv.s
   local v = hsv.v

   local i = math.floor(h * 6)
   local f = h * 6 - i
   local p = v * (1 - s)
   local q = v * (1 - f * s)
   local t = v * (1 - (1 - f) * s)

   i = i % 6

   if i == 0 then r, g, b = v, t, p
   elseif i == 1 then r, g, b = q, v, p
   elseif i == 2 then r, g, b = p, v, t
   elseif i == 3 then r, g, b = p, q, v
   elseif i == 4 then r, g, b = t, p, v
   elseif i == 5 then r, g, b = v, p, q
   end

   return RgbColor(r, g, b)
end

function color_util.hsv_lerp(left, right, factor, allow_extrapolation)
   return HsvColor(
   util.clamp(util.lerp(left.h, right.h, factor, allow_extrapolation), 0, 1),
   util.clamp(util.lerp(left.s, right.s, factor, allow_extrapolation), 0, 1),
   util.clamp(util.lerp(left.v, right.v, factor, allow_extrapolation), 0, 1))

end

function color_util.hsv_to_hex(hsv)
   return color_util.rgb_to_hex(color_util.hsv_to_rgb(hsv))
end

function color_util.add_hsv_brightness(hsv, increment)
   return HsvColor(hsv.h, hsv.s, util.clamp(hsv.v + increment, 0, 1))
end

function color_util.add_rgb_brightness(rgb, increment)
   return color_util.hsv_to_rgb(color_util.add_hsv_brightness(color_util.rgb_to_hsv(rgb), increment))
end

function color_util.scale_rgb_brightness(rgb, factor)
   local hsv = color_util.rgb_to_hsv(rgb)

   local new_v = hsv.v * factor

   if new_v < 0 then
      new_v = 0
   end

   if new_v > 1 then
      new_v = 1
   end

   return color_util.hsv_to_rgb(HsvColor(hsv.h, hsv.s, new_v))
end

function color_util.hsv_to_hsv_int(hsv)
   return { util.round(hsv.h * 360.0), util.round(hsv.s * 100.0), util.round(hsv.v * 100.0) }
end

function color_util.hsv_int_to_hsv(hsv_values)
   return HsvColor(hsv_values[1] / 360.0, hsv_values[2] / 100.0, hsv_values[3] / 100.0)
end

function color_util.hsv_int_to_hex(hsv_values)
   return color_util.hsv_to_hex(color_util.hsv_int_to_hsv(hsv_values))
end

function color_util.hsv_palette_int_to_hsv_palette(hsv_palette_int)
   local accents = {}
   for _, hsv in ipairs(hsv_palette_int.accents) do
      table.insert(accents, color_util.hsv_int_to_hsv(hsv))
   end
   local result = {
      name = hsv_palette_int.name,
      background_mode = hsv_palette_int.background_mode,
      background = color_util.hsv_int_to_hsv(hsv_palette_int.background),
      foreground = color_util.hsv_int_to_hsv(hsv_palette_int.foreground),
      accents = accents,
   }
   return result
end

function color_util.hsv_palette_to_hsv_palette_int(hsv_palette)
   local accents = {}
   for _, hsv in ipairs(hsv_palette.accents) do
      table.insert(accents, color_util.hsv_to_hsv_int(hsv))
   end
   local result = {
      name = hsv_palette.name,
      background_mode = hsv_palette.background_mode,
      background = color_util.hsv_to_hsv_int(hsv_palette.background),
      foreground = color_util.hsv_to_hsv_int(hsv_palette.foreground),
      accents = accents,
   }
   return result
end

function color_util.hex_palette_to_hsv_palette(hex_palette)
   return {
      name = hex_palette.name,
      background_mode = hex_palette.background_mode,
      background = color_util.hex_to_hsv(hex_palette.background),
      foreground = color_util.hex_to_hsv(hex_palette.foreground),
      accents = {
         color_util.hex_to_hsv(hex_palette.accents[1]),
         color_util.hex_to_hsv(hex_palette.accents[2]),
         color_util.hex_to_hsv(hex_palette.accents[3]),
         color_util.hex_to_hsv(hex_palette.accents[4]),
         color_util.hex_to_hsv(hex_palette.accents[5]),
         color_util.hex_to_hsv(hex_palette.accents[6]),
         color_util.hex_to_hsv(hex_palette.accents[7]),
      },
   }
end

class.setup(color_util, "color_util")

return color_util
