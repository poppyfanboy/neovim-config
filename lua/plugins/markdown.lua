return {
    {
        'iamcco/markdown-preview.nvim',
        ft = 'markdown',
        build = function()
            vim.fn['mkdp#util#install']()
        end,
    },
    {
        'dkarter/bullets.vim',
        ft = 'markdown',
        event = 'InsertEnter',
    },
    {
        'dhruvasagar/vim-table-mode',
        cmd = { 'TableModeToggle' },
    },
}
