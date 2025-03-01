--- @class expect: luassert
_G.expect = require "luassert"

_G.skip = {
  --- @type fun(name: string, block: function)
  describe = function(name, block) end,
  --- @type fun(name: string, block: function)
  it = function(name, block) end,
}

_G.todo = {
  --- @type fun(name: string)
  describe = function(name) end,
  --- @type fun(name: string)
  it = function(name) end,
}
