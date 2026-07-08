-- Charcoal & Amber — tokyonight restyled. Source of truth: ~/dev/desktop-theme.md
local p = {
    bg = "#131110",
    surface = "#1a1715",
    black = "#201d1a",
    sel = "#3a332c",
    border = "#2c2621",
    muted = "#8f8578",
    text = "#d6cfc4",
    bright = "#ece5d8",
    amber = "#d9a05b",
    amber_br = "#e6b479",
    clay = "#c4675c",
    clay_br = "#d07f72",
    olive = "#a3a961",
    olive_br = "#b5bb74",
    slate = "#7d94a8",
    slate_br = "#93a9bc",
    mauve = "#b087a3",
    mauve_br = "#c29cb5",
    teal = "#8aa8a0",
    teal_br = "#b3d1c9", -- deliberate spec deviation (ANSI bright cyan is #9fbcb4): too close to normal teal for adjacent syntax tokens
}

return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            style = "night",
            transparent = false,
            terminal_colors = true,
            styles = {
                comments = { italic = false },
                keywords = { italic = false },
                sidebars = "dark",
                floats = "dark",
            },
            on_colors = function(c)
                -- surfaces
                c.bg = p.bg
                c.bg_dark = p.surface
                c.bg_float = p.surface
                c.bg_popup = p.surface
                c.bg_sidebar = p.surface
                c.bg_statusline = p.surface
                c.bg_highlight = p.black
                c.bg_visual = p.sel
                c.bg_search = p.amber
                c.border = p.border
                c.border_highlight = p.muted
                c.black = p.bg
                c.terminal_black = p.black
                c.dark3 = p.sel
                c.dark5 = p.muted
                -- text
                c.fg = p.text
                c.fg_dark = p.text
                c.fg_float = p.text
                c.fg_sidebar = p.muted
                c.fg_gutter = p.sel
                c.comment = p.muted
                -- hues (earth-muted ANSI from the spec)
                c.blue = p.slate
                c.blue0 = p.sel
                c.blue1 = p.teal_br
                c.blue2 = p.teal
                c.blue5 = p.slate_br
                c.blue6 = p.teal_br
                c.blue7 = p.sel
                c.cyan = p.teal
                c.teal = p.teal
                c.green = p.olive
                c.green1 = p.teal
                c.green2 = p.teal
                c.magenta = p.mauve
                c.magenta2 = p.clay
                c.purple = p.mauve
                c.orange = p.amber
                c.yellow = p.amber_br
                c.red = p.clay
                c.red1 = p.clay_br
                -- semantics
                c.error = p.clay
                c.warning = p.amber_br
                c.info = p.slate
                c.hint = p.teal
                c.todo = p.amber
                c.git = { add = p.olive, change = p.amber, delete = p.clay, ignore = p.muted }
                -- diff backgrounds: palette hues blended ~20% into bg
                c.diff = { add = "#302f20", change = "#3b2e1f", delete = "#36221f", text = p.sel }
            end,
            on_highlights = function(hl, c)
                -- unused code: same color as line numbers (default terminal_black too dark)
                hl.DiagnosticUnnecessary = { fg = c.fg_gutter }
                -- amber search needs dark text, not the default light fg
                hl.Search = { bg = p.amber, fg = p.bg }
                hl.IncSearch = { bg = p.amber_br, fg = p.bg }
                hl.CurSearch = { bg = p.amber_br, fg = p.bg }
            end,
        },
    },
}
