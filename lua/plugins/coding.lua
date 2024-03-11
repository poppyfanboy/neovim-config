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
                ['~'] = {
                    input = { '~~().-()~~' },
                    output = { left = '~~', right = '~~' },
                },
            },
        },
        event = 'LazyFile',
    },
    {
        'numToStr/Comment.nvim',
        config = true,
        keys = {
            { 'gcc', mode = 'n', desc = 'Comment toggle current line' },
            { 'gc', mode = { 'n', 'o' }, desc = 'Comment toggle linewise' },
            { 'gc', mode = 'x', desc = 'Comment toggle linewise (visual)' },
            { 'gbc', mode = 'n', desc = 'Comment toggle current block' },
            { 'gb', mode = { 'n', 'o' }, desc = 'Comment toggle blockwise' },
            { 'gb', mode = 'x', desc = 'Comment toggle blockwise (visual)' },
        },
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
