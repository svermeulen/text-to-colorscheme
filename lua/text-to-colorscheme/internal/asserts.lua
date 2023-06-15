local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local math = _tl_compat and _tl_compat.math or math; local pcall = _tl_compat and _tl_compat.pcall or pcall; local string = _tl_compat and _tl_compat.string or string
local Asserts = {}


local function _raise(format, ...)
   if format == nil then
      error("[text-to-colorscheme] Assert hit!")
   else
      error(string.format("[text-to-colorscheme] " .. format, ...))
   end
end

function Asserts.fail(format, ...)
   _raise(format, ...)
end

function Asserts.that(condition, format, ...)
   if not condition then
      _raise(format, ...)
   end
end

function Asserts.throws(action)
   local ok = pcall(action)
   if ok then
      _raise("Expected exception when calling given function but no error was found!")
   end
end

function Asserts.is_nil(value, format, ...)
   if value ~= nil then
      _raise(format, ...)
   end
end

function Asserts.is_not_nil(value, format, ...)
   if value == nil then
      _raise(format, ...)
   end
end

function Asserts.is_equal(left, right, format, ...)
   if left ~= right then
      if format == nil then
         _raise("Expected '%s' (left) to equal '%s' (right)", left, right)
      else
         _raise(format, ...)
      end
   end
end

function Asserts.is_not_equal(left, right, format, ...)
   if left == right then
      if format == nil then
         _raise("Expected '%s' (left) to not equal '%s' (right)", left, right)
      else
         _raise(format, ...)
      end
   end
end

function Asserts.is_type(value, expected_type_name, format, ...)
   local value_type_name = type(value)
   if value_type_name ~= expected_type_name then
      if format == nil then
         _raise("Expected type '%s' but instead found type '%s'", expected_type_name, value_type_name)
      else
         _raise(format, ...)
      end
   end
end

function Asserts.is_string(value, format, ...)
   Asserts.is_type(value, "string", format, ...)
end

function Asserts.is_number(value, format, ...)
   Asserts.is_type(value, "number", format, ...)
end

function Asserts.is_integer(value, format, ...)
   Asserts.is_type(value, "number", format, ...)

   local value_num = value
   Asserts.that(math.abs(value_num - math.floor(value_num)) < 0.0001, "Expected integer value but instead found '%s'", value)
end

function Asserts.is_table(value, format, ...)
   Asserts.is_type(value, "table", format, ...)
end

function Asserts.is_thread(value, format, ...)
   Asserts.is_type(value, "thread", format, ...)
end

function Asserts.is_userdata(value, format, ...)
   Asserts.is_type(value, "userdata", format, ...)
end

function Asserts.is_function(value, format, ...)
   Asserts.is_type(value, "function", format, ...)
end

function Asserts.is_boolean(value, format, ...)
   Asserts.is_type(value, "boolean", format, ...)
end

return Asserts
