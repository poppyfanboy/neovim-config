return {
    {
        'chrisbra/unicode.vim',
        cmd = { 'UnicodeTable', 'Digraphs', 'UnicodeSearch' },
    },
    {
        'folke/todo-comments.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'folke/trouble.nvim',
        },
        keys = {
            {
                '<leader>tT',
                function()
                    require('trouble').open('todo')
                end,
                mode = { 'n' },
                desc = '[t]oggle [T]ODO list',
            },
        },
        opts = {
            signs = false,
        },
    },
    {
        'poppyfanboy/toggleterm.nvim',
        opts = {
            direction = 'float',
            open_mapping = '<f1>',
            shell = function()
                return vim.o.shell
            end,
        },
        cmd = { 'ToggleTerm', 'TermExec' },
        keys = {
            { '<f1>' },
        },
    },
}
