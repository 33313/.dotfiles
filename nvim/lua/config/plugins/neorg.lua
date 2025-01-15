return {
    "nvim-neorg/neorg",
    tag = "v7.0.0",
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = true,
    ft = "norg",
    cmd = "Neorg",
    build = ":Neorg sync-parsers",
    config = function()
        require("neorg").setup {
            load = {
                ["core.defaults"] = {},
                ["core.integrations.treesitter"] = {},
                ["core.export"] = {},
                ["core.keybinds"] = {
                    config = {
                        neorg_leader = " "
                    }
                },
                ["core.concealer"] = {
                    config = {
                        folds = false
                    }
                },
                ["core.dirman"] = {
                    config = {
                        workspaces = {
                            notes = "$HOME/notes",
                        },
                    },
                },
            },
        }
    end,
}
