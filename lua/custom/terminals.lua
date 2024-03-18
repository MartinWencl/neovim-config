-- Terminal setup

-- Autocmd -> deletes terminal buffers after leaving
-- Does it with all terminal buffers
-- TODO: Implement persistent terminal buffer
vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "term://*",
  group = vim.api.nvim_create_augroup("Terminal", { clear = true }),
  callback = function ()
    local buf = vim.api.nvim_get_current_buf()
    if buf == nil then return end

    vim.api.nvim_buf_delete(buf, { force = true })
  end
})

-- Bottom terminal
local bottom_terminal = {}

--- Toggles bottom terminal, similar to `vs code`
local toggle_bottom_term = function()
  -- Need to check if the window is still open, as it could have been closed using <C-w>q and not by this fn
  if vim.fn.winheight(bottom_terminal.win) == -1 then
    bottom_terminal.win = nil
  end

  if bottom_terminal.win == nil then
    local height = 8 -- height in rows

    vim.cmd("below split")
    vim.cmd.terminal()
    vim.cmd("startinsert")
    local win = vim.api.nvim_get_current_win()
    bottom_terminal.win = win
    vim.api.nvim_win_set_height(win, height)
    vim.api.nvim_buf_call(vim.api.nvim_win_get_buf(win), function ()
      vim.keymap.set("n", "q", "<Cmd>q!<CR>", { silent = true })
      vim.keymap.set("n", "<esc>", "<Cmd>q!<CR>", { silent = true })
      vim.keymap.set("n", ";", "<Cmd>q!<CR>", { silent = true })
    end)
  else
    local buf = vim.api.nvim_win_get_buf(bottom_terminal.win)
    vim.api.nvim_buf_delete(buf, { force = true })
    vim.api.nvim_win_close(bottom_terminal.win, false)
    bottom_terminal.win = nil
  end
end

vim.api.nvim_create_user_command("TermBottom", toggle_bottom_term, {})

--- drop-down terminal, like Yakuake.
-- TODO: make toggle
local quake_style_terminal = {}

local toggle_quake_term = function()
  local buf = quake_style_terminal.buf
  if buf == nil then
    buf = vim.api.nvim_create_buf(false, true)
    quake_style_terminal.buf = buf
  end

  local ui = vim.api.nvim_list_uis()[1]
  local width = ui.width
  local height = 15
  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    col = 0,
    row = 0,
    anchor = 'NW',
    style = 'minimal',
    border = 'rounded',
  }

  vim.api.nvim_open_win(buf, true, opts)
  vim.cmd.terminal()
  vim.cmd("startinsert")
  vim.api.nvim_buf_call(buf, function ()
    vim.keymap.set("n", "q", "<Cmd>q!<CR>", { silent = true })
    vim.keymap.set("n", "<esc>", "<Cmd>q!<CR>", { silent = true })
    vim.keymap.set("n", ";", "<Cmd>q!<CR>", { silent = true })
  end)
end

vim.api.nvim_create_user_command("TermQuake", toggle_quake_term, {})
