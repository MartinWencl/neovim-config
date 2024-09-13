-- https://github.com/nvim-neorg/neorg
-- FIX: Norg/Neorg filetype is not registered! - telescope rendering does not work
return {
    "nvim-neorg/neorg",
    dependencies = {
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-neorg/neorg-telescope' },
    },
    version = "*",
    config = function()
        require("neorg").setup({
            load = {
                ['core.defaults'] = {},  -- Loads default behaviour
                ['core.concealer'] = {}, -- Adds pretty icons to your documents
                -- ["core.completion"] = {  -- Adds completion
                --     engine = "cmp",
                --     name = "neorg"
                -- },
                ['core.dirman'] = { -- Manages Neorg workspaces
                    config = {
                        workspaces = {
                            main = "~/notes/",
                        },
                    },
                },
                ['core.integrations.treesitter'] = {},
                ['core.export'] = {},
                ['core.integrations.telescope'] = {},
                ['core.summary'] = {},
                ['core.esupports.hop'] = {},
                -- ['core.mode'] = {},
            },
        })

        -- Keybinds groups setup
        local wk = require("which-key")
        wk.register({
            ["<leader>"] = {
                n = {
                    name = "[n]eorg",
                },
            },
            ["<leader>n"] = {
                w = {
                    name = "[w]orkspace",
                },
            },
        })

        -- Workspaces
        vim.keymap.set("n", "<leader>nw", "<Cmd>Neorg workspace main<CR>", { desc = "[w]ork" })

        -- -- iterate trough workspaces
        -- local switch_modes = function()
        --     local mode_module = require("neorg").modules.get_module("core.mode")
        --     local all_modes = mode_module.get_modes()
        --     local current_mode = mode_module.get_mode()
        --
        --     -- Setting next mode
        --     local current_index = 0
        --     for i, module in ipairs(all_modes) do
        --         if module == current_mode then
        --             current_index = i
        --         end
        --
        --         if i == current_index + 1 then
        --             mode_module.set_mode(module)
        --             vim.notify("Neorg mode set to " .. module, vim.log.levels.INFO)
        --         end
        --     end
        -- end
        -- vim.keymap.set("n", "<leader>ns", switch_modes, { desc = "[s]witch mode" })
        --
        -- local read_mode = function()
        --     local mode_module = require("neorg").modules.get_module("core.mode")
        --     local mode = mode_module.add_mode("links-follow")
        -- end

        -- Go to index
        vim.keymap.set("n", "<leader>ni", "<Cmd>Neorg index<CR>", { desc = "goto [i]ndex" })
        -- vim.keymap.set("n", "<leader>nt", read_mode, { desc = "goto [i]ndex" })

        -- Insert links
        vim.keymap.set("n", "<leader>nl", "<Cmd>Telescope neorg insert_link<CR>", { desc = "insert [l]ink" })
        vim.keymap.set("n", "<leader>nf", "<Cmd>Telescope neorg insert_file_link<CR>", { desc = "insert [f]ile link" })

        vim.wo.foldlevel = 99
        vim.wo.conceallevel = 2
    end,
}
