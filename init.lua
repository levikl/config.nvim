require("custom.lazy")

vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamedplus" -- pressing "p" pastes clipboard buffer
vim.opt.number = true
vim.opt.relativenumber = true

-- source the most recently saved version of current file
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
-- source the current line
vim.keymap.set("n", "<space>x", ":.lua<CR>")
-- (in visual mode) source the current line
vim.keymap.set("v", "<space>x", ":lua<CR>")

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
