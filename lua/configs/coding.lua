vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    pattern = {'*.vert', '*.frag'},
    callback = function()
        vim.o.filetype = 'glsl'
    end,
})
