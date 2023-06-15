
local asserts <const> = require("text-to-colorscheme.internal.asserts")

local record util
end

function util.starts_with(value:string, prefix:string):boolean
   return value:sub(1, #prefix) == prefix
end

function util.is_approximately_equal(left:number, right:number, epsilon:number):boolean
   return math.abs(left - right) <= epsilon
end

function util.lerp(left:number, right:number, factor:number, allow_extrapolation:boolean):number
   asserts.that(allow_extrapolation or (factor >= 0 and factor <= 1))
   return left + (right - left) * factor
end

function util.clamp(value:number, min:number, max:number):number
   asserts.that(min <= max)

   if value < min then
      value = min
   end

   if value > max then
      value = max
   end

   return value
end

function util.split(value:string, sep:string):{string}
   local result = { }
   local cnt = 1

   for x in string.gmatch(value, "([^" .. tostring(sep) .. "]+)") do
     result[cnt] = x
     cnt = cnt + 1
   end
   return result
end

function util.round(value:number):integer
   return math.floor(value + 0.5)
end

function util.shuffle(list:{any}):{any}
    local n = #list
    while n > 1 do
        local k = math.random(n)
        list[n], list[k] = list[k], list[n]
        n = n - 1
    end
    return list
end

function util.shallow_clone<T>(source:T):T
   if source is table then
      local copy = {}
      for orig_key, orig_value in pairs(source) do
         copy[orig_key] = orig_value
      end
      return copy as T
   end

   -- number, string, boolean, etc
   return source
end

return util
