return {
    'nvim-telescope/telescope.nvim', version = 'v0.2.1',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Find files' })
        vim.keymap.set('n', '<leader>ps', builtin.live_grep, { desc = 'Live grep' })
        --[[
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") });
        end)
        ]]--
    end,
}
