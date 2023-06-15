local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local string = _tl_compat and _tl_compat.string or string
local class = require("text-to-colorscheme.internal.class")
local util = require("text-to-colorscheme.internal.util")

local HsvColor = {}







function HsvColor:__init(h, s, v)
   self.h = h
   self.s = s
   self.v = v
end

function HsvColor:is_equal(that)
   return self.h == that.h and self.s == that.s and self.v == that.v
end

function HsvColor:__tostring()
   return string.format("HSV(%s, %s, %s)", tostring(self.h), tostring(self.s), tostring(self.v))
end

function HsvColor:is_approximately_equal(that, epsilon)
   return util.is_approximately_equal(self.h, that.h, epsilon) and
   util.is_approximately_equal(self.s, that.s, epsilon) and
   util.is_approximately_equal(self.v, that.v, epsilon)
end

class.setup(HsvColor, "HsvColor", { immutable = true })

return HsvColor
