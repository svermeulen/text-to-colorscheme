local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local string = _tl_compat and _tl_compat.string or string
local class = require("text-to-colorscheme.internal.class")
local asserts = require("text-to-colorscheme.internal.asserts")

local RgbColorInt = {}







function RgbColorInt:is_equal(that)
   return self.r == that.r and self.b == that.b and self.g == that.g
end

function RgbColorInt:to_string()
   return string.format("(%s, %s, %s)", tostring(self.r), tostring(self.g), tostring(self.b))
end

function RgbColorInt:__init(r, g, b)
   asserts.that(r >= 0 and r <= 255)
   asserts.that(g >= 0 and g <= 255)
   asserts.that(b >= 0 and b <= 255)

   self.r = r
   self.g = g
   self.b = b
end

class.setup(RgbColorInt, "RgbColorInt", { immutable = true })

return RgbColorInt
