return {
    {
        'iamcco/markdown-preview.nvim',
        build = function()
            vim.fn.call('mkdp#util#install', {})
        end,
    },
    {
        'dkarter/bullets.vim',
        ft = { 'markdown' },
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
