local ROCKS_TREE = assert(vim.env.ROCKS_TREE)
vim.o.rtp = vim.o.rtp .. "," .. ROCKS_TREE .. "/lib/lua/5.1"

vim.o.modeline = true -- disabled by default in CI
vim.o.shadafile = "NONE"
vim.o.swapfile = false
