
local record Asserts
end

local function _raise(format:string, ...:any)
   if format == nil then
      error("[text-to-colorscheme] Assert hit!")
   else
      error(string.format("[text-to-colorscheme] " .. format, ...))
   end
end

function Asserts.fail(format:string, ...:any)
   _raise(format, ...)
end

function Asserts.that(condition:boolean, format:string, ...:any)
   if not condition then
      _raise(format, ...)
   end
end

function Asserts.throws(action:function())
   local ok = pcall(action)
   if ok then
      _raise("Expected exception when calling given function but no error was found!")
   end
end

function Asserts.is_nil(value:any, format:string, ...:any)
   if value ~= nil then
      _raise(format, ...)
   end
end

function Asserts.is_not_nil(value:any, format:string, ...:any)
   if value == nil then
      _raise(format, ...)
   end
end

function Asserts.is_equal(left:any, right:any, format:string, ...:any)
   if left ~= right then
      if format == nil then
         _raise("Expected '%s' (left) to equal '%s' (right)", left, right)
      else
         _raise(format, ...)
      end
   end
end

function Asserts.is_not_equal(left:any, right:any, format:string, ...:any)
   if left == right then
      if format == nil then
         _raise("Expected '%s' (left) to not equal '%s' (right)", left, right)
      else
         _raise(format, ...)
      end
   end
end

function Asserts.is_type(value:any, expected_type_name:string, format:string, ...:any)
   local value_type_name = type(value)
   if value_type_name ~= expected_type_name then
      if format == nil then
         _raise("Expected type '%s' but instead found type '%s'", expected_type_name, value_type_name)
      else
         _raise(format, ...)
      end
   end
end

function Asserts.is_string(value:any, format:string, ...:any)
   Asserts.is_type(value, "string", format, ...)
end

function Asserts.is_number(value:any, format:string, ...:any)
   Asserts.is_type(value, "number", format, ...)
end

function Asserts.is_integer(value:any, format:string, ...:any)
   Asserts.is_type(value, "number", format, ...)
   
   local value_num = value as number
   Asserts.that(math.abs(value_num - math.floor(value_num)) < 0.0001, "Expected integer value but instead found '%s'", value)
end

function Asserts.is_table(value:any, format:string, ...:any)
   Asserts.is_type(value, "table", format, ...)
end

function Asserts.is_thread(value:any, format:string, ...:any)
   Asserts.is_type(value, "thread", format, ...)
end

function Asserts.is_userdata(value:any, format:string, ...:any)
   Asserts.is_type(value, "userdata", format, ...)
end

function Asserts.is_function(value:any, format:string, ...:any)
   Asserts.is_type(value, "function", format, ...)
end

function Asserts.is_boolean(value:any, format:string, ...:any)
   Asserts.is_type(value, "boolean", format, ...)
end

return Asserts

