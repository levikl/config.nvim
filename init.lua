require("custom.lazy")
require("custom.floaterminal")

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
vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")              -- (opt-j) select next item in quickfix
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")              -- (opt-k) select prev item in quickfix
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")            -- breaks out of terminal mode

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

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

local job_id = 0
vim.keymap.set("n", "<space>st", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 15)

  job_id = vim.bo.channel
end)

-- vim.keymap.set("n", "<space>example", function()
--   -- go build, go test ./asdfasdf
--   vim.fn.chansend(job_id, { "ls -al\r\n" })
-- end)

local current_command = ""
vim.keymap.set("n", "<space>te", function()
  current_command = vim.fn.input("Command: ")
end)

vim.keymap.set("n", "<space>tr", function()
  if current_command == "" then
    current_command = vim.fn.input("Command: ")
  end

  vim.fn.chansend(job_id, { current_command .. "\r\n" })
end)
