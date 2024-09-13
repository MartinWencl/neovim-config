-- Sets leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- TODO: set shada

-- Sets EOL char
vim.opt.list = true
vim.opt.listchars = {
  eol = "󰌑"
}

-- vim.opt.inccommand = "split"

-- Sets spelling
vim.opt.spelllang = {"en_us", "cs"}
vim.opt.spell = true

-- Sets splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Sets scrolloff - keeps the cursor centered to the middle
vim.opt.scrolloff = 999

-- Sets the line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Turns off linewrap
vim.opt.wrap = false

-- Syncs system clipboard
vim.opt.clipboard = "unnamedplus"

-- Sets highlight on search
vim.o.hlsearch = false

-- Sets breakindent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- Enable better colors
vim.o.termguicolors = true

-- Sets highlighting on yank
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- Sets winbar
vim.opt.winbar = "%=%m %f"
