local common = require('common')

vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = { 'yaml' },
    callback = function()
        vim.bo.tabstop = 2
        vim.bo.softtabstop = 2
        vim.bo.shiftwidth = 2
        vim.bo.expandtab = true
    end,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
    callback = function(args)
        local file_size = 0

        local buffer_name = vim.api.nvim_buf_get_name(args.buf)
        if buffer_name ~= '' then
            local ok, stats = pcall(vim.loop.fs_stat, buffer_name)
            if ok and stats then
                file_size = stats.size
            end
        end

        vim.b['too_large_for_treesitter'] = file_size > common.too_large_for_treesitter
        vim.b['way_too_large'] = file_size > common.way_too_large

        if file_size > common.way_too_large then
            vim.b['matchup_matchparen_enabled'] = false
            vim.wo.foldmethod = 'manual'
            vim.wo.foldexpr = ''
        else
            vim.opt_local.syntax = 'on'
        end
    end,
})

-- https://github.com/nvim-treesitter/nvim-treesitter/pull/6580#issuecomment-2098953281
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'haskell' },
    callback = function()
        vim.b['matchup_matchparen_enabled'] = false
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('Spell', { clear = true }),
    pattern = { 'markdown', 'gitcommit' },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = { 'en_us', 'ru' }
    end,
})

vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
        local sign_bg = vim.api.nvim_get_hl(0, { name = 'SignColumn' }).bg

        -- https://github.com/mfussenegger/nvim-dap/discussions/355
        vim.fn.sign_define('DapBreakpoint', { text = '󰝤', texthl = 'DapBreakpoint' })
        vim.api.nvim_set_hl(0, 'DapBreakpoint', { bg = sign_bg, fg = '#e82424' })

        vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped' })
        vim.api.nvim_set_hl(0, 'DapStopped', { bg = sign_bg, fg = '#98bb6c' })
    end,
})
