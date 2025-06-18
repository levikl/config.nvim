require("custom.lazy")

vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamedplus" -- pressing "p" pastes clipboard buffer
vim.opt.number = true
vim.opt.relativenumber = true

-- these make option+<key> keymaps functional on mac
vim.cmd.nmap('˙ <M-h>')
vim.cmd.nmap('∆ <M-j>')
vim.cmd.nmap('˚ <M-k>')
vim.cmd.nmap('¬ <M-l>')
vim.cmd.nmap('Ø <M-O>')
vim.cmd.nmap('ø <M-o>')

vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>") -- source the most recently saved version of current file
vim.keymap.set("n", "<space>x", ":.lua<CR>")                -- source the current line (in normal mode)
vim.keymap.set("v", "<space>x", ":lua<CR>")                 -- source the current line (in visual mode)
vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")

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
