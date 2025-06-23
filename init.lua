require "custom.lazy"

vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamedplus" -- pressing "p" pastes clipboard buffer
vim.opt.number = true
vim.opt.relativenumber = true

-- Highlight when yanking (copying) text
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
