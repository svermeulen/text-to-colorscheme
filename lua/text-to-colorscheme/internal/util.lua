local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local math = _tl_compat and _tl_compat.math or math; local pairs = _tl_compat and _tl_compat.pairs or pairs; local string = _tl_compat and _tl_compat.string or string
local asserts = require("text-to-colorscheme.internal.asserts")

local util = {}


function util.starts_with(value, prefix)
   return value:sub(1, #prefix) == prefix
end

function util.is_approximately_equal(left, right, epsilon)
   return math.abs(left - right) <= epsilon
end

function util.lerp(left, right, factor, allow_extrapolation)
   asserts.that(allow_extrapolation or (factor >= 0 and factor <= 1))
   return left + (right - left) * factor
end

function util.clamp(value, min, max)
   asserts.that(min <= max)

   if value < min then
      value = min
   end

   if value > max then
      value = max
   end

   return value
end

function util.split(value, sep)
   local result = {}
   local cnt = 1

   for x in string.gmatch(value, "([^" .. tostring(sep) .. "]+)") do
      result[cnt] = x
      cnt = cnt + 1
   end
   return result
end

function util.round(value)
   return math.floor(value + 0.5)
end

function util.shuffle(list)
   local n = #list
   while n > 1 do
      local k = math.random(n)
      list[n], list[k] = list[k], list[n]
      n = n - 1
   end
   return list
end

function util.shallow_clone(source)
   if type(source) == "table" then
      local copy = {}
      for orig_key, orig_value in pairs(source) do
         copy[orig_key] = orig_value
      end
      return copy
   end


   return source
end

return util
