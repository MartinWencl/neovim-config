-- Load neovim options - no plugins
require("opts")

-- Bootstrapping lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

-- adding lazy to runtimepath
-- :h :runtime
vim.opt.rtp:prepend(lazypath)

-- Loads some basic plugins
local plugins = require("plugins.init_plugins")

-- Set the lua/plugins/ as the import dir for additional plugins
table.insert(plugins, { import = "plugins" })

require("lazy").setup(plugins, {
    change_detection = {
        notify = false,
    },
})

-- Load basic keymaps not related to specific plugins
require("keymaps")

-- Load custom files
require("custom.dek")
require("custom.delphi")
require("custom.terminals")
