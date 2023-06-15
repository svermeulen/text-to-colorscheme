
local asserts = require("text-to-colorscheme.internal.asserts")

local Class = {}

function Class.try_get_name(instance)
  if instance == nil or type(instance) ~= "table" then
    return nil
  end
  local class = instance.__class
  if class == nil then
    return nil
  end
  return class.__name
end

function Class.get_name(instance)
  local name = Class.try_get_name(instance)
  if name == nil then
    error("Attempted to get class name for non-class type!")
  end
  return name
end

function Class.setup(class, class_name, options)
  class.__name = class_name
  options = options or {}

  if options.getters then
    for k, v in pairs(options.getters) do
      if type(v) == "string" then
        asserts.that(class[v] ~= nil, "Found getter property '%s' mapped to non-existent method '%s' for class '%s'", k, v, class_name)
      end
    end
  end

  if options.setters then
    for k, v in pairs(options.setters) do
      if type(v) == "string" then
        asserts.that(class[v] ~= nil, "Found setter property '%s' mapped to non-existent method '%s' for class '%s'", k, v, class_name)
      end
    end
  end

  -- Assume closed by default
  local is_closed = true

  if options.closed ~= nil and not options.closed then
    is_closed = false
  end

  local is_immutable = false

  if options.immutable ~= nil and options.immutable then
    is_immutable = true
  end

  if is_immutable then
    asserts.that(is_closed, "Attempted to create a non-closed immutable class '%s'.  This is not allowed", class_name)
  end

  local function create_immutable_wrapper(t, _)
    local proxy = {}
    local mt = {
        __index = t,
        __newindex = function(_, k, _)
            asserts.fail("Attempted to change field '%s' of immutable class '%s'", k, class_name)
        end,
        __len = function() 
            return #t 
        end,
        __pairs = function() 
            return pairs(t) 
        end,
        __ipairs = function()
            return ipairs(t)
        end,
        __tostring = function()
            return tostring(t)
        end
    }
    setmetatable(proxy, mt)
    return proxy
  end

  setmetatable(
     class, { 
       __call = function(_, ...)
         local mt = {}
         local instance = setmetatable({ __class = class }, mt)

         -- We need to call __init before defining __newindex below
         -- This is also nice because all classes are required to define
         -- default values for all their members in __init
         if class.__init ~= nil then
           class.__init(instance, ...)
         end

         local tostring_handler = class["__tostring"]
         if tostring_handler ~= nil then
           mt.__tostring = tostring_handler
         end

         mt.__index = function(_, k)
           if options.getters then
             local getter_value = options.getters[k]
             if getter_value then
               if type(getter_value) == "string" then
                 return class[getter_value](instance)
               end

               return getter_value(instance)
             end
           end

           local static_member = class[k]
           if is_closed then
             -- This check means that member values cannot ever be set to nil
             -- So we provide the closed flag to allow for this case
             asserts.that(static_member ~= nil, "Attempted to set non-existent member '%s' on class '%s'.  If its valid for the class to have nil members, then pass 'closed=false' to class.setup", k, class_name)
           end
           return static_member
         end

         mt.__newindex = function(_, k, value)
           if is_closed then
             asserts.that(options.setters, "Attempted to set non-existent property '%s' on class '%s'", k, class_name)

             local setter_value = options.setters[k]
             asserts.that(setter_value, "Attempted to set non-existent property '%s' on class '%s'", k, class_name)

             if type(setter_value) == "string" then
               rawget(class, setter_value)(instance, value)
             else
               setter_value(instance, value)
             end
           else
             asserts.that(not is_immutable)
             rawset(instance, k, value)
           end
         end

         if is_immutable then
           return create_immutable_wrapper(instance, class_name)
         end

         return instance
       end,
     }
  )
end

return Class
