local assert = require "luassert"
local nio = require "nio"
local it = nio.tests.it
local before_each = nio.tests.before_each
local after_each = nio.tests.after_each

local fennel_fixture = "./tests/fixtures/fixture.fnl"

vim.o.modeline = true

before_each(function()
  assert.equal("", vim.fn.expand "%")
  assert.equal(1, #vim.api.nvim_list_bufs())
end)

after_each(function()
  vim.cmd "%bwipeout"
end)

describe("the test environment", function()
  it("loads the test fixture", function()
    vim.cmd.edit(fennel_fixture)
    assert.equal(fennel_fixture, vim.fn.expand "%")
  end)

  it("identifies the test fixture's filetype", function()
    vim.cmd.edit(fennel_fixture)
    assert.equal("fennel", vim.bo.filetype)
  end)
end)
