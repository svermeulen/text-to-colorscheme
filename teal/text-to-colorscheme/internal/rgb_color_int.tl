
local class <const> = require("text-to-colorscheme.internal.class")
local asserts <const> = require("text-to-colorscheme.internal.asserts")

local record RgbColorInt
   r:integer
   g:integer
   b:integer

   metamethod __call: function(self: RgbColorInt, r:integer, g:integer, b:integer): RgbColorInt
end

function RgbColorInt:is_equal(that:RgbColorInt):boolean
   return self.r == that.r and self.b == that.b and self.g == that.g
end

function RgbColorInt:to_string():string
   return string.format("(%s, %s, %s)", tostring(self.r), tostring(self.g), tostring(self.b))
end

function RgbColorInt:__init(r:integer, g:integer, b:integer)
   asserts.that(r >= 0 and r <= 255)
   asserts.that(g >= 0 and g <= 255)
   asserts.that(b >= 0 and b <= 255)

   self.r = r
   self.g = g
   self.b = b
end

class.setup(RgbColorInt, "RgbColorInt", { immutable = true })

return RgbColorInt
