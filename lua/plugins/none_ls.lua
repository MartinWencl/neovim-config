-- https://github.com/nvimtools/none-ls.nvim
-- NOTE: LSP wrapper for command line Utilities
-- can be used for linters and formatter
return {
    "nvimtools/none-ls.nvim",
    config = function()
        local null_ls = require("null-ls")

    null_ls.setup {
      sources = {
        null_ls.builtins.formatting.stylua,
        -- null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.completion.spell,
      },
    }
        vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(0, "Format", function(_)
            vim.lsp.buf.format()
        end, { desc = "format current buffer with lsp" })
    end,
}
