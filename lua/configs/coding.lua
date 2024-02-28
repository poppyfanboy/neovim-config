vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = { '*.vert', '*.frag' },
    callback = function()
        vim.bo.filetype = 'glsl'
    end,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = { 'yaml' },
    callback = function()
        vim.bo.tabstop = 2
        vim.bo.softtabstop = 2
        vim.bo.shiftwidth = 2
        vim.bo.expandtab = true
    end,
})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = { '*.h' },
    callback = function()
        vim.bo.filetype = 'c'
    end,
})
