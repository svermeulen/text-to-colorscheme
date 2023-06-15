
local class <const> = require("text-to-colorscheme.internal.class")
local util <const> = require("text-to-colorscheme.internal.util")
local asserts <const> = require("text-to-colorscheme.internal.asserts")

local record RgbColor
   r:number
   g:number
   b:number

   metamethod __call: function(self: RgbColor, r:number, g:number, b:number): RgbColor
end

function RgbColor:__init(r:number, g:number, b:number)
   asserts.that(r >= 0 and r <= 1)
   asserts.that(g >= 0 and g <= 1)
   asserts.that(b >= 0 and b <= 1)

   self.r = r
   self.g = g
   self.b = b
end

function RgbColor:is_equal(that:RgbColor):boolean
   return self.r == that.r and self.b == that.b and self.g == that.g
end

function RgbColor:is_approximately_equal(that:RgbColor, epsilon:number):boolean
   asserts.is_not_nil(epsilon)
   return util.is_approximately_equal(self.r, that.r, epsilon) and 
      util.is_approximately_equal(self.b, that.b, epsilon) and 
      util.is_approximately_equal(self.g, that.g, epsilon)
end

function RgbColor:__tostring():string
   return string.format("RGB(%s, %s, %s)", tostring(self.r), tostring(self.g), tostring(self.b))
end

class.setup(RgbColor, "RgbColor", { immutable = true })

return RgbColor
