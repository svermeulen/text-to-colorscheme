
-- TODO - change to use generics
local record SetupOptions
   getters:{string:string|function(any):any}
   setters:{string:string|function(any, any)}

   -- Closed = no new keys except in __init method
   closed:boolean
   -- Immutable = no changes to values except in __init method
   immutable:boolean
end

local record Class
   setup:function(rec:any, name:string, options:SetupOptions)
   get_name:function(any):string
   try_get_name:function(any):string
end

return Class
