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
            "c",
            "lua",
            "vim",
            "vimdoc",
            "markdown",
            "toml",
            "bash",
            "yaml",
            "javascript",
            "typescript",
            "query",
            "go",
            "gomod",
            "python",
            "css",
            "tsx"
        })
        vim.api.nvim_create_autocmd("BufReadPost", {
            pattern = "*",
            callback = function()
                pcall(vim.treesitter.start) -- errors for ft with no parser
            end
        })
    end
}
