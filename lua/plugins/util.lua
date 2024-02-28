return {
    {
        'chrisbra/unicode.vim',
        cmd = { 'UnicodeTable', 'Digraphs' },
    },
    {
        'tyru/open-browser.vim',
        keys = {
            { 'gx', '<Plug>(openbrowser-smart-search)', mode = { 'n', 'v' } },
        },
    },
    {
        'folke/trouble.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            auto_preview = false,
        },
        keys = {
            {
                '<leader>tt',
                '<cmd>Trouble workspace_diagnostics<cr>',
                mode = { 'n' },
                desc = '[t]oggle [t]rouble',
            },
            {
                '<leader>tx',
                '<cmd>TroubleClose<cr>',
                mode = { 'n' },
                desc = 'Close the trouble window',
            },
        },
        cmd = { 'Trouble', 'TroubleClose' },
    },
    {
        'folke/todo-comments.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'folke/trouble.nvim',
        },
        config = true,
        keys = {
            {
                '<leader>tT',
                '<cmd>Trouble todo<cr>',
                mode = { 'n' },
                desc = '[t]oggle [T]ODO list',
            },
        },
    },
    {
        'akinsho/toggleterm.nvim',
        version = '*',
        event = { 'VeryLazy' },
        opts = {
            direction = 'float',
            open_mapping = '<f1>',
            shell = function()
                return vim.o.shell
            end,
        },
    },
}
