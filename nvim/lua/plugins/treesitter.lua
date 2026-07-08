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
            -- QoL
            "toml", "bash", "yaml",
            -- Web
            "javascript", "typescript", "tsx", "html", "css",
            -- Other
            "query",
            "go", "gomod",
        })
        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "*",
            callback = function()
                pcall(vim.treesitter.start) -- errors for ft with no parser
            end
        })
    end
}
