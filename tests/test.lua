--- @type Luassert
local assert = require "luassert"

local nio = require "nio"
local it = nio.tests.it
local before_each = nio.tests.before_each
local after_each = nio.tests.after_each

local fennel_fixture = "./tests/fixtures/fixture.fnl"
local timeout = vim.env.CI and 1000 or 100

before_each(function()
  assert.equal("", vim.fn.expand "%")
  assert.equal(1, #vim.api.nvim_list_bufs())
end)

after_each(function()
  vim.cmd "%bwipeout"
end)

describe("the test environment", function()
  it("loads the treesitter parser", function()
    assert.no_error(function()
      vim.treesitter.language.inspect "fennel"
    end)
  end)

  it("loads the test fixture", function()
    vim.cmd.edit(fennel_fixture)
    assert.equal(fennel_fixture, vim.fn.expand "%")
  end)

  it("identifies the test fixture's filetype", function()
    vim.cmd.edit(fennel_fixture)
    assert.equal("fennel", vim.bo.filetype)
  end)

  it("parses the test fixture", function()
    vim.cmd.edit(fennel_fixture)
    assert.no_error(function()
      vim.treesitter.get_parser()
    end)
  end)

  it("attaches the language server client", function()
    vim.cmd.edit(fennel_fixture)
    nio.sleep(timeout)

    --- @diagnostic disable-next-line: deprecated
    local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
    local clients = get_clients { bufnr = 0 }

    assert.equal(1, #clients)
    assert.equal("fennel-ls", clients[1].name)
  end)
end)
