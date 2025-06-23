local set = vim.keymap.set

-- these make option+<key> keymaps functional on mac
vim.cmd.nmap "˙ <M-h>"
vim.cmd.nmap "∆ <M-j>"
vim.cmd.nmap "˚ <M-k>"
vim.cmd.nmap "¬ <M-l>"
vim.cmd.nmap "Ø <M-O>"
vim.cmd.nmap "ø <M-o>"

set("n", "<M-j>", "<cmd>cnext<CR>") -- (opt-j) select next item in quickfix
set("n", "<M-k>", "<cmd>cprev<CR>") -- (opt-k) select prev item in quickfix

--vim.api.nvim_set_keymap("n", "<leader>t", "<Plug>PlenaryTestFile", { noremap = false, silent = false })
