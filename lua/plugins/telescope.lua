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
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = "make",
        cond = function()
          return vim.fn.executable "make" == 1
        end,
      },
    },
    config = function()
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require("telescope").setup {
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
      }

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
        local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")
            [1]
        if vim.v.shell_error ~= 0 then
          print "Not a git repository. Searching on current working directory"
          return cwd
        end
        return git_root
      end

      -- Custom live_grep function to search in git root
      local function live_grep_git_root()
        local git_root = find_git_root()
        if git_root then
          require("telescope.builtin").live_grep {
            search_dirs = { git_root },
          }
        end
      end

      local builtin = require("telescope.builtin")
      local actions = require("telescope.actions")

      -- See `:help telescope.builtin`
      vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "[?] Find recently opened files" })
      vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "[/] Fuzzily search in current buffer" })
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
      vim.keymap.set("n", "<leader>sj", builtin.jumplist, { desc = "[s]earch [j]umplist"})

    local send_to_qflsit = function ()
        local bufnr = vim.api.nvim_get_current_buf()
        actions.smart_send_to_qflist.pre(bufnr)
    end
      vim.keymap.set("n", "<C-q>", send_to_qflsit, { desc = "[s]earch [j]umplist"})
    end
  },
}
