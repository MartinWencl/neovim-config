--- Metatable containing all the window helper functions
WindowLib = {}

--- Opens a floating window centered in the middle of the screen
--- @param width number width of the window in chars
--- @param height number height of the window in chars
--- @param bufnr number buffer that will be used
function WindowLib:open_floating_window (width, height, bufnr)
  local ui = vim.api.nvim_list_uis()[1]

  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    col = (ui.width / 2) - (width / 2),
    row = (ui.height / 2) - (height / 2),
    anchor = 'NW',
    style = 'minimal',
  }
  vim.api.nvim_open_win(bufnr, true, opts)
end
