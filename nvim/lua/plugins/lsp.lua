return {
    {
        'williamboman/mason.nvim',
        opts = {},
    },
    {
        'hrsh7th/nvim-cmp',
        lazy = false,
        event = 'InsertEnter',
        dependencies = {
            { 'L3MON4D3/LuaSnip' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-nvim-lua' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'rafamadriz/friendly-snippets' },
        },
        config = function()
            local cmp = require('cmp')
            local cmp_select = { behavior = cmp.SelectBehavior.Select }
            require('luasnip.loaders.from_vscode').lazy_load()

            cmp.setup({
                sources = {
                    { name = 'nvim_lsp', group_index = 0 },
                    { name = 'luasnip',  group_index = 1 },
                    { name = 'buffer' },
                    { name = 'path' },
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-Space>'] = cmp.mapping.complete(),
                }),
                snippet = {
                    expand = function(args)
                        vim.snippet.expand(args.body)
                    end,
                },
            })
        end
    },
    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
        },
        init = function()
            vim.opt.signcolumn = 'yes'
        end,
        config = function()
            local lsp_defaults = require('lspconfig').util.default_config

            lsp_defaults.capabilities = vim.tbl_deep_extend(
                'force',
                lsp_defaults.capabilities,
                require('cmp_nvim_lsp').default_capabilities()
            )
            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(_, bufnr)
                    local opts = { buffer = bufnr, remap = false }
                    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
                    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
                    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
                    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
                    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
                    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
                    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
                end,
            })

            require('mason-lspconfig').setup({
                ensure_installed = {
                    'lua_ls',
                    'gopls',
                    'basedpyright',
                    'ruff',
                    'html',
                    'ts_ls',
                    'cssls',
                    'yamlls',
                    'jsonls',
                    'clangd'
                },
                handlers = {
                    function(server_name)
                        vim.lsp.enable(server_name)
                    end,
                },
                automatic_enable = true,
            })
        end
    }
}
