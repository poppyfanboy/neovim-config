return {
    {
        'iamcco/markdown-preview.nvim',
        build = function()
            vim.fn['mkdp#util#install']()
        end,
    },
    {
        'dkarter/bullets.vim',
        event = 'InsertEnter',
    },
    {
        'godlygeek/tabular',
        cmd = { 'Tabularize' },
    },
    {
        'dhruvasagar/vim-table-mode',
        cmd = { 'TableModeToggle' },
    },
}
