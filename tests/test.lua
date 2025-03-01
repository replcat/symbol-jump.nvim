local expect = require "luassert"
local nio = require "nio"
local it = nio.tests.it

it("works", function()
  expect.equal(type(vim), "table")
end)

it("works (async)", function()
  local event = nio.control.event()

  local notified = 0
  for _ = 1, 10 do
    nio.run(function()
      event.wait()
      notified = notified + 1
    end)
  end

  event.set()
  nio.sleep(100)

  expect.equal(10, notified)
end)
