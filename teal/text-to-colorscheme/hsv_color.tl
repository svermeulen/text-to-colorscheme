
local class <const> = require("text-to-colorscheme.internal.class")
local util <const> = require("text-to-colorscheme.internal.util")

local record HsvColor
   h:number
   s:number
   v:number

   metamethod __call: function(self: HsvColor, h:number, s:number, v:number): HsvColor
end

function HsvColor:__init(h:number, s:number, v:number)
   self.h = h
   self.s = s
   self.v = v
end

function HsvColor:is_equal(that:HsvColor):boolean
   return self.h == that.h and self.s == that.s and self.v == that.v
end

function HsvColor:__tostring():string
   return string.format("HSV(%s, %s, %s)", tostring(self.h), tostring(self.s), tostring(self.v))
end

function HsvColor:is_approximately_equal(that:HsvColor, epsilon:number):boolean
   return util.is_approximately_equal(self.h, that.h, epsilon) and 
      util.is_approximately_equal(self.s, that.s, epsilon) and 
      util.is_approximately_equal(self.v, that.v, epsilon)
end

class.setup(HsvColor, "HsvColor", { immutable = true })

return HsvColor
