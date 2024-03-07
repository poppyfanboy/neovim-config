return {
    {
        'echasnovski/mini.surround',
        opts = {
            custom_surroundings = {
                -- 'i' for italic in markdown
                ['i'] = {
                    input = { '_().-()_' },
                    output = { left = '_', right = '_' },
                },
                ['_'] = {
                    input = { '__().-()__' },
                    output = { left = '__', right = '__' },
                },
            },
        },
        event = 'LazyFile',
    },
    {
        'numToStr/Comment.nvim',
        config = true,
        event = 'LazyFile',
    },
    {
        'Wansmer/treesj',
        event = 'LazyFile',
        opts = {
            use_default_keymaps = false,
        },
        keys = {
            {
                '<leader>as',
                [[<cmd>lua require('treesj').split()<cr>]],
                desc = '[a]rguments [s]plit (treesj)',
            },
            {
                '<leader>aj',
                [[<cmd>lua require('treesj').join()<cr>]],
                desc = '[a]rguments [j]join (treesj)',
            },
        },
    },
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = true,
    },
    {
        'folke/flash.nvim',
        event = 'LazyFile',
        opts = {
            modes = {
                search = { enabled = false },
            },
        },
        keys = {
            {
                'gs',
                mode = { 'n', 'o', 'x' },
                function()
                    require('flash').jump()
                end,
            },
        },
    },
}
