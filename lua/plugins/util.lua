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
        config = true,
        keys = {
            { '<leader>tt', '<cmd>TroubleToggle<cr>', mode = { 'n' }, desc = '[t]oggle [t]rouble' },
        },
        cmd = { 'TroubleToggle' },
    },
    {
        'folke/todo-comments.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'folke/trouble.nvim',
        },
        config = true,
        keys = {
            { '<leader>tT', '<cmd>TodoTrouble<cr>', mode = { 'n' }, desc = '[t]oggle [T]ODO list' },
        },
        cmd = { 'TodoTrouble' },
    },
}
