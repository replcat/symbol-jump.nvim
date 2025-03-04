local ROCKS_TREE = assert(vim.env.ROCKS_TREE)
vim.o.rtp = vim.o.rtp .. "," .. ROCKS_TREE .. "/lib/lua/5.1"

vim.o.modeline = true -- disabled by default in CI
vim.o.shadafile = "NONE"
vim.o.swapfile = false

--- @diagnostic disable-next-line: deprecated
local fennel_ls = assert(vim.lsp.start_client {
  name = "fennel-ls",
  cmd = { assert(vim.env.ROCKS_TREE) .. "/bin/fennel-ls" },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "fennel",
  callback = function(args)
    local ok = vim.lsp.buf_attach_client(args.buf, fennel_ls)
    assert(ok)
  end,
})
