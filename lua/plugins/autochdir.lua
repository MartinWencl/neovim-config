return {
    "albenisolmos/autochdir.nvim",
    config = function()
        require('autochdir').setup {
            -- Useful for not accidentally jumping to other projects and staying in the first project found
            keep_dir = false,

            -- Define flags by file extension (default: {})
            flags = {
                ['rs'] = {'Cargo.toml'},
                -- ['c'] = {'Makefile', 'CMake'}
            },
            -- Define generic flags for all files
            generic_flags = { 'README.md', '.git' }

            -- Autochair will first find flags from 'flags' and then from 'generic flags'
        }
    end
}
