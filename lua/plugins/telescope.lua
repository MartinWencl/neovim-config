return {
    -- Fuzzy Finder (files, lsp, etc)
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            -- Only load if `make` is available. Make sure you have the system
            -- requirements installed.
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            "nvim-neorg/neorg",
        },
        config = function()
            -- [[ Configure Telescope ]]
            -- See `:help telescope` and `:help telescope.setup()`
            require("telescope").setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-u>"] = false,
                            ["<C-d>"] = false,
                        },
                    },
                    file_ignore_patterns = { "__history" },
                    -- borderchars = { "█", " ", "▀", "█", "█", " ", " ", "▀" },
                },
            })

            -- Enable telescope fzf native, if installed
            pcall(require("telescope").load_extension, "fzf")

            -- Telescope live_grep in git root
            -- Function to find the git root directory based on the current buffer"s path
            local function find_git_root()
                -- Use the current buffer"s path as the starting point for the git search
                local current_file = vim.api.nvim_buf_get_name(0)
                local current_dir
                local cwd = vim.fn.getcwd()
                -- If the buffer is not associated with a file, return nil
                if current_file == "" then
                    current_dir = cwd
                else
                    -- Extract the directory from the current file"s path
                    current_dir = vim.fn.fnamemodify(current_file, ":h")
                end

                -- Find the Git root directory from the current file"s path
                local git_root = vim.fn.systemlist("git -C " ..
                vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
                if vim.v.shell_error ~= 0 then
                    print("Not a git repository. Searching on current working directory")
                    return cwd
                end
                return git_root
            end

            -- Custom live_grep function to search in git root
            local function live_grep_git_root()
                local git_root = find_git_root()
                if git_root then
                    require("telescope.builtin").live_grep({
                        search_dirs = { git_root },
                    })
                end
            end

            local builtin = require("telescope.builtin")
            local actions = require("telescope.actions")

            --- Helper function to set some custom options for the builtin funcs
            --- Needs to be a function, as it needs to work with the state when called - not at init
            ---@param builtin_func function
            ---@param opts table
            ---@return function
            --- NOTE: The options ARE NOT one to one with the default telescope options
            local set_builtin_opts = function(builtin_func, opts)
                -- Options to be passed to the builtin function, see :h telescope.builtin
                -- These must be just the telescope options
                local builtin_opts = {}

                if opts.insert_from_reg then
                  local selection = string.gsub(vim.fn.getreg("opts.insert_from_reg"), "\n", "")
                  builtin_opts["default_text"] = selection
                end

                if opts.visual_selection then
                    local _, start_row, start_col, _ = unpack(vim.fn.getpos("v"))
                    local _, end_row, end_col, _ = unpack(vim.fn.getpos("."))
                    -- FIX: it's empty
                    local visual_selection = vim.api.nvim_buf_get_text(0, start_row, start_col - 1, end_row, end_col - 1,
                        {})

                    builtin_opts["default_text"] = table.concat(visual_selection, " ")
                end

                if opts.prompt_title then
                    builtin_opts["prompt_title"] = opts.prompt_title
                end

                return function()
                    builtin_func(builtin_opts)
                end
            end

            vim.keymap.set("v", "<leader>t", function()
                local _, start_row, start_col, _ = unpack(vim.fn.getpos("v"))
                local _, end_row, end_col, _ = unpack(vim.fn.getpos("."))
                local visual_selection = vim.api.nvim_buf_get_text(0, start_row, start_col - 1, end_row, end_col - 1, {})
                vim.schedule(function()
                    vim.print(visual_selection)
                end)
            end)


            -- HACK: Two copies of searching in current buffer - i want both <leader>/ and <leader>s/ for consistency with other search keybinds
            vim.keymap.set(
                { "n", "v" },
                "<leader>s/",
                set_builtin_opts(builtin.current_buffer_fuzzy_find, { visual_selection = true, prompt_title = "test" }),
                { desc = "[/] Fuzzily search in current buffer" }
            )
            vim.keymap.set(
                { "n", "v" },
                "<leader>/",
                set_builtin_opts(builtin.current_buffer_fuzzy_find, { visual_selection = true, prompt_title = "test" }),
                { desc = "[/] Fuzzily search in current buffer" }
            )

            -- NOTE: I don't really use this, no need to do the same as with current buff
            vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })

            -- vim.keymap.set("n", "<leader>gf", require("telescope.builtin").git_files, { desc = "Search [G]it [F]iles" })
            vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
            vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
            vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
            vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
            vim.keymap.set("n", "<leader>sG", live_grep_git_root, { desc = "[S]earch by [G]rep on Git Root" })
            vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
            vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
            vim.keymap.set("n", "<leader>sc", builtin.git_commits, { desc = "[s]earch [g]it [c]ommits" })
            vim.keymap.set("n", "<leader>sbc", builtin.git_bcommits, { desc = "[s]earch [b]uffer [g]it [c]ommits" })
            vim.keymap.set("n", "<leader>sb", builtin.git_branches, { desc = "[s]earch [g]it [b]ranches" })
            vim.keymap.set("n", "<leader>sj", builtin.jumplist, { desc = "[s]earch [j]umplist" })

            -- TODO: For now this sends all the search results to the quickfix,
            -- change that only the selected ones are sent
            local send_to_qflsit = function()
                local bufnr = vim.api.nvim_get_current_buf()
                actions.smart_send_to_qflist.pre(bufnr)
            end
            vim.keymap.set("n", "<C-q>", send_to_qflsit, { desc = "[s]earch [j]umplist" })
        end,
    },
}
