
require("busted")

local class = require("text-to-colorscheme.internal.class")
local asserts = require("text-to-colorscheme.internal.asserts")

describe("class", function()
   describe("basic functionality", function()
      local Foo = {}




      function Foo:__init()
         self.qux = 5
      end

      function Foo:get_bar()
         return "asdf"
      end

      class.setup(Foo, "Foo")

      it("can call member methods", function()
         local foo = Foo()
         asserts.is_equal(foo:get_bar(), "asdf")
      end)

      it("can access member fields", function()
         local foo = Foo()
         asserts.is_equal(foo.qux, 5)
      end)

      it("can change member fields", function()
         local foo = Foo()
         foo.qux = 9
         asserts.is_equal(foo.qux, 9)
      end)
   end)

   describe("invalid member access", function()
      local Foo = {}







      class.setup(Foo, "Foo")

      it("accessing non members fails", function()
         local foo = Foo()

         asserts.throws(function()
            local _ = foo.asdf
         end)

         asserts.throws(function()
            foo.zxcv()
         end)
      end)
   end)

   describe("immutable fields", function()
      local Foo = {}




      function Foo:__init()
         self.qux = 5
      end

      function Foo:get_bar()
         return "asdf"
      end

      class.setup(Foo, "Foo", {
         immutable = true,
      })

      it("can call member methods", function()
         local foo = Foo()
         asserts.is_equal(foo:get_bar(), "asdf")
      end)

      it("can access member fields", function()
         local foo = Foo()
         asserts.is_equal(foo.qux, 5)
      end)

      it("cannot change member fields", function()
         local foo = Foo()
         asserts.throws(function()
            foo.qux = 9
         end)
         asserts.is_equal(foo.qux, 5)
      end)
   end)

   describe("properties simple", function()
      local Foo = {}






      function Foo:__init()
         self.set_dorp_value = "unset"
      end

      function Foo:_get_qux()
         return 5
      end

      function Foo:_set_dorp(value)
         self.set_dorp_value = value
      end

      class.setup(Foo, "Foo", {
         getters = {
            ["qux"] = "_get_qux",
         },
         setters = {
            ["dorp"] = "_set_dorp",
         },
      })

      it("getter", function()
         asserts.is_equal(Foo().qux, 5)
      end)

      it("setter", function()
         local foo = Foo()
         asserts.is_equal(foo.set_dorp_value, "unset")
         foo.dorp = "asdf"
         asserts.is_equal(foo.set_dorp_value, "asdf")
      end)
   end)

   describe("properties both getter and setter", function()
      local Foo = {}




      local _qux = 0

      function Foo:_get_qux()
         return _qux
      end

      function Foo:_set_qux(value)
         _qux = value
      end

      class.setup(Foo, "Foo", {
         getters = {
            ["qux"] = "_get_qux",
         },
         setters = {
            ["qux"] = "_set_qux",
         },
      })

      it("can get and set", function()
         local foo = Foo()
         asserts.is_equal(foo.qux, 0)
         foo.qux = 5
         asserts.is_equal(foo.qux, 5)
      end)
   end)
end)
