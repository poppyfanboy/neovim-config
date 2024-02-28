-- https://neovim.io/doc/user/tips.html#hex-editing

if vim.fn.executable('xxd') == 0 then
    return
end

local binary_files_patterns = { '*.bin', '*.gif' }
local binary_autocmd_group = vim.api.nvim_create_augroup('Binary', { clear = true })

vim.api.nvim_create_autocmd({ 'BufReadPre' }, {
    pattern = binary_files_patterns,
    group = binary_autocmd_group,
    callback = function()
        vim.b['xxd_binary_file'] = true

        vim.bo.binary = true
        vim.wo.spell = false
    end,
})

vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
    pattern = binary_files_patterns,
    group = binary_autocmd_group,
    callback = function()
        if not vim.b['xxd_binary_file'] then
            return
        end

        vim.cmd([[ silent %!xxd ]])
        vim.bo.filetype = 'xxd'
        vim.cmd.redraw()
    end,
})

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    pattern = binary_files_patterns,
    group = binary_autocmd_group,
    callback = function()
        if not vim.b.xxd_binary_file then
            return
        end

        vim.b['xxd_saved_view'] = vim.fn.winsaveview()
        vim.cmd([[ silent %!xxd -r ]])
    end,
})

vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
    pattern = binary_files_patterns,
    group = binary_autocmd_group,
    callback = function()
        if not vim.b.xxd_binary_file then
            return
        end

        vim.cmd([[ silent %!xxd ]])
        vim.bo.modified = false
        vim.fn.winrestview(vim.b['xxd_saved_view'])
        vim.cmd.redraw()
    end,
})
