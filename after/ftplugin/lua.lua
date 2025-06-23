local set = vim.keymap.set

vim.opt.shiftwidth = 2
vim.opt.expandtab = true

set("n", "<space><space>x", "<cmd>source %<CR>") -- source the most recently saved version of current file
set("n", "<space>x", ":.lua<CR>") -- source the current line (in normal mode)
set("v", "<space>x", ":lua<CR>") -- source the current line (in visual mode)

set("n", "<space>tf", "<cmd>PlenaryBustedFile %<CR>")
