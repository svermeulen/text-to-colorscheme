local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local string = _tl_compat and _tl_compat.string or string
local class = require("text-to-colorscheme.internal.class")
local util = require("text-to-colorscheme.internal.util")
local asserts = require("text-to-colorscheme.internal.asserts")

local RgbColor = {}







function RgbColor:__init(r, g, b)
   asserts.that(r >= 0 and r <= 1)
   asserts.that(g >= 0 and g <= 1)
   asserts.that(b >= 0 and b <= 1)

   self.r = r
   self.g = g
   self.b = b
end

function RgbColor:is_equal(that)
   return self.r == that.r and self.b == that.b and self.g == that.g
end

function RgbColor:is_approximately_equal(that, epsilon)
   asserts.is_not_nil(epsilon)
   return util.is_approximately_equal(self.r, that.r, epsilon) and
   util.is_approximately_equal(self.b, that.b, epsilon) and
   util.is_approximately_equal(self.g, that.g, epsilon)
end

function RgbColor:__tostring()
   return string.format("RGB(%s, %s, %s)", tostring(self.r), tostring(self.g), tostring(self.b))
end

class.setup(RgbColor, "RgbColor", { immutable = true })

return RgbColor
