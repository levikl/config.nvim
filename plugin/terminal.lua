vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>") -- breaks out of terminal mode

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

-- local job_id = 0
-- vim.keymap.set("n", "<space>st", function()
--   vim.cmd.vnew()
--   vim.cmd.term()
--   vim.cmd.wincmd "J"
--   vim.api.nvim_win_set_height(0, 15)
--
--   job_id = vim.bo.channel
-- end)

-- vim.keymap.set("n", "<space>example", function()
--   -- go build, go test ./asdfasdf
--   vim.fn.chansend(job_id, { "ls -al\r\n" })
-- end)

-- local current_command = ""
-- vim.keymap.set("n", "<space>te", function()
--   current_command = vim.fn.input "Command: "
-- end)

-- vim.keymap.set("n", "<space>tr", function()
--   if current_command == "" then
--     current_command = vim.fn.input "Command: "
--   end
--
--   vim.fn.chansend(job_id, { current_command .. "\r\n" })
-- end)

local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  -- Calculate the position to center the window
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  -- Create a buffer
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
  end

  -- Define window configuration
  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal", -- No borders or extra UI elements
    border = "rounded",
  }

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.keymap.set({ "n", "t" }, "<space>tp", toggle_terminal)
