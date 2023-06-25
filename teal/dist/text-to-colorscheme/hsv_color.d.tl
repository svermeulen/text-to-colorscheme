
local record HsvColor
   h:number
   s:number
   v:number

   is_equal:function(HsvColor, that:HsvColor):boolean
   is_approximately_equal:function(HsvColor, that:HsvColor, epsilon:number):boolean
   metamethod __call: function(self: HsvColor, h:number, s:number, v:number): HsvColor
end

return HsvColor
