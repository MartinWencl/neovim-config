-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- change split navigation to <C-[direction]>
-- vim.keymap.set("n", "<c-j>", "<c-w><c-j>")
-- vim.keymap.set("n", "<c-k>", "<c-w><c-k>")
-- vim.keymap.set("n", "<c-l>", "<c-w><c-l>")
-- vim.keymap.set("n", "<c-h>", "<c-w><c-h>")

-- Split resizing
vim.keymap.set( "n", "<M-j>", "<c-w>-")
vim.keymap.set( "n", "<M-k>", "<c-w>+")
vim.keymap.set( "n", "<M-l>", "<c-w>5<")
vim.keymap.set( "n", "<M-h>", "<c-w>5>")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Execute current line
vim.keymap.set("n", "<leader>x", "<Cmd>.lua<CR>", { desc = "Execute the current line" })
-- Source file
vim.keymap.set("n", "<leader><leader>x", "<Cmd>source %<CR>", { desc = "Source current file" })

-- Open floating diagnostic window
vim.keymap.set(
  "n",
  "<leader>i",
  ':lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})<CR>',
  { desc = "Open floating diagnostic window", silent = true }
)

-- Change the crazy default terminal escape keymap to esc
vim.keymap.set("t", "<esc>", "<C-\\><C-n>", { silent = true })

-- File management keybindings
vim.keymap.set("n", "<leader>e", "<Cmd>Neotree toggle<CR>")

-- Turn off arrow keys in normal and insert mode
-- vim.keymap.set({"n", "i"}, "<left>", "")
-- vim.keymap.set({"n", "i"}, "<right>", "")
-- vim.keymap.set({"n", "i"}, "<up>", "")
-- vim.keymap.set({"n", "i"}, "<down>", "")
