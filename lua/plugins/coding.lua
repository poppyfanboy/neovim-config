return {
    {
        'echasnovski/mini.surround',
        config = function()
            require('mini.surround').setup()
        end,
        event = 'VeryLazy',
    },
    {
        'numToStr/Comment.nvim',
        config = true,
        event = 'VeryLazy',
    },
    {
        'Wansmer/treesj',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        },
        config = function()
            local treesj = require('treesj')

            treesj.setup({
                use_default_keymaps = false,
            })
        end,
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
        'cohama/lexima.vim',
        event = { 'BufReadPost', 'BufNewFile' },
    },
    {
        'folke/flash.nvim',
        event = 'VeryLazy',
        opts = {},
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
