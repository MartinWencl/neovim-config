local enable_ai = function()
    -- if vim.g.is_code_private() then
    --     return false
    -- end
    return true
    -- return true
end

return {

    -- custom config which piggybacks on the copilot extras in lazy.lua.
    {
        "zbirenbaum/copilot.lua",
        enabled = enable_ai,
        dependencies = {
            "hrsh7th/nvim-cmp",
        },
        cmd = "Copilot",
        build = ":Copilot auth",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                panel = {
                    enabled = true,
                    auto_refresh = true,
                },
                suggestion = {
                    enabled = true,
                    -- use the built-in keymapping for "accept" (<M-l>)
                    auto_trigger = true,
                    accept = false, -- disable built-in keymapping
                },
            })

            -- hide copilot suggestions when cmp menu is open
            -- to prevent odd behavior/garbled up suggestions
            local cmp_status_ok, cmp = pcall(require, "cmp")
            if cmp_status_ok then
                cmp.event:on("menu_opened", function()
                    vim.b.copilot_suggestion_hidden = true
                end)

                cmp.event:on("menu_closed", function()
                    vim.b.copilot_suggestion_hidden = false
                end)
            end

            vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "*",
            group = "CopilotShowSuggestion",
            callback = function()
                vim.b.copilot_suggestion_hidden = false
            end
        })
    end,
    },

    { "AndreM222/copilot-lualine" },

    -- https://github.com/jackMort/ChatGPT.nvim
    {
        "jackMort/ChatGPT.nvim",
        dependencies = {
            { "MunifTanjim/nui.nvim" },
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope.nvim" },
        },
        -- event = "VeryLazy",
        config = function()
            require("chatgpt").setup({
                api_key_cmd = "/home/martinw/.config/nvim/secret.sh",
                actions_paths = {},
                openai_params = {
                    model = "gpt-4",
                    max_tokens = 4000,
                },
                openai_edit_params = {
                    model = "gpt-3.5-turbo",
                    temperature = 0,
                    top_p = 1,
                    n = 1,
                },
            })
        end,
    },

    -- {
    -- help:
    -- /modellist
    -- /model  <model name from model list>
    -- /replace <number from code suggestion>
    -- exit with CTRL+C
    --     "dustinblackman/oatmeal.nvim",
    --     cmd = { "Oatmeal" },
    --     keys = {
    --         { "<leader>om", mode = "n", desc = "Start Oatmeal session" },
    --     },
    --     opts = {
    --         backend = "ollama",
    --         model = "codellama:latest",
    --     },
    -- },
}
