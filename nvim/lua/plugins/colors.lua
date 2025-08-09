---Sets a theme; equivalent of :colorscheme [theme]
---@param theme string Name of the theme to use
function setTheme(theme)
    theme = theme or "tokyonight"
    vim.cmd.colorscheme(theme)
end

return {
    { "Mofiqul/vscode.nvim" },
    { "tanvirtin/monokai.nvim" },
    {
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                style = "night",
                transparent = false,
                terminal_colors = true,
                styles = {
                    comments = { italic = false },
                    keywords = { italic = false },
                    sidebars = "dark",
                    floats = "dark",
                },
            })
        end
    }
}
