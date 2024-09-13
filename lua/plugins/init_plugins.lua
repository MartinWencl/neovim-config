return {
    -- Git
    "tpope/vim-fugitive",
    "tpope/vim-rhubarb",

    -- Tabstop and shiftwidth
    "tpope/vim-sleuth",

    -- Better lua
    "folke/neodev.nvim",

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",

            -- Adds LSP completion capabilities
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",

            -- Adds a number of user-friendly snippets
            "rafamadriz/friendly-snippets",
        },
        source = {
            { name = "neorg" },
        },
        config = function()
            -- [[ Configure nvim-cmp ]]
            -- See `:help cmp`
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            require("luasnip.loaders.from_vscode").lazy_load()
            luasnip.config.setup({})

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete({}),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                },
            })
        end,
    },

    -- Which-key to show help on pending keybinds
    { "folke/which-key.nvim",  opts = {} },

    -- Adds git related signs to the gutter, as well as utilities for managing changes
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
        },
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map({ "n", "v" }, "]c", function()
                if vim.wo.diff then
                    return "]c"
                end
                vim.schedule(function()
                    gs.next_hunk()
                end)
                return "<Ignore>"
            end, { expr = true, desc = "Jump to next hunk" })

            map({ "n", "v" }, "[c", function()
                if vim.wo.diff then
                    return "[c"
                end
                vim.schedule(function()
                    gs.prev_hunk()
                end)
                return "<Ignore>"
            end, { expr = true, desc = "Jump to previous hunk" })

            -- FIX: keybinds don't work currently

            -- Actions
            -- visual mode
            map("v", "<leader>hs", function()
                gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, { desc = "stage git hunk" })
            map("v", "<leader>hr", function()
                gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, { desc = "reset git hunk" })
            -- normal mode
            map("n", "<leader>hs", gs.stage_hunk, { desc = "git stage hunk" })
            map("n", "<leader>hr", gs.reset_hunk, { desc = "git reset hunk" })
            map("n", "<leader>hS", gs.stage_buffer, { desc = "git Stage buffer" })
            map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "undo stage hunk" })
            map("n", "<leader>hR", gs.reset_buffer, { desc = "git Reset buffer" })
            map("n", "<leader>hp", gs.preview_hunk, { desc = "preview git hunk" })
            map("n", "<leader>hb", function()
                gs.blame_line({ full = false })
            end, { desc = "git blame line" })
            map("n", "<leader>hd", gs.diffthis, { desc = "git diff against index" })
            map("n", "<leader>hD", function()
                gs.diffthis("~")
            end, { desc = "git diff against last commit" })

            -- Toggles
            map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "toggle git blame line" })
            map("n", "<leader>td", gs.toggle_deleted, { desc = "toggle git show deleted" })

            -- Text object
            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select git hunk" })
        end,
    },

    -- Set lualine as statusline
    {
        "nvim-lualine/lualine.nvim",
        -- See `:help lualine.txt`
        --
        opts = {
            options = {
                icons_enabled = true,
                theme = "catppuccin",
                -- component_separators = "|",
                -- section_separators = "",
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = { "filename" },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
        },
    },

    -- Add indentation guides even on blank lines
    {
    "lukas-reineke/indent-blankline.nvim",
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = "ibl",
    opts = {},
    config = function()
    require("ibl").setup()
    end
    },
    -- Add easy commenting
    { "numToStr/Comment.nvim", opts = {} },
}
