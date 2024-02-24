vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = { '*.vert', '*.frag' },
    callback = function()
        vim.o.filetype = 'glsl'
    end,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = { 'yaml' },
    callback = function()
        vim.o.tabstop = 2
        vim.o.softtabstop = 2
        vim.o.shiftwidth = 2
        vim.o.expandtab = true
    end,
})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = { '*.h' },
    callback = function()
        vim.o.filetype = 'c'
    end,
})
