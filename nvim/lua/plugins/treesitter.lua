return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    opts = {
        sync_install = false,
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false
        },
        autotag = {
            enable = true,
            enable_rename = true,
            enable_close = true,
            enable_close_on_slash = false
        },
        indent = {
            enable = true
        }
    },
    config = function()
        require('nvim-treesitter').install({
            -- Neovim deps
            "c", "lua", "vim", "vimdoc", "markdown",
            -- Languages
            "javascript", "typescript", "query", "go", "gomod", "python",
            -- Web
            "css", "tsx"
        })
    end
}
