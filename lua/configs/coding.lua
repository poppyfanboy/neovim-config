vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = { '*.vert', '*.frag' },
    callback = function()
        vim.o.filetype = 'glsl'
    end,
})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = { '*.h' },
    callback = function()
        vim.o.filetype = 'c'
    end,
})
