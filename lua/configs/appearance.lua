local listchars = {
    eol = '󰘌',
    trail = '_',
    space = '·',
    tab = '-->',
}

local lsp_signs = {
    Error = ' ',
    Warn = ' ',
    Hint = '󰌶 ',
    Information = ' ',
}

local fillchars = {
    diff = '╱',
}

vim.o.guifont = 'Iosevka Nerd Font:h14'

vim.o.list = true
for listchar_name, listchar_value in pairs(listchars) do
    vim.opt.listchars:append(string.format('%s:%s', listchar_name, listchar_value))
end

for fillchar_name, fillchar_value in pairs(fillchars) do
    vim.opt.fillchars:append(string.format('%s:%s', fillchar_name, fillchar_value))
end

vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
        local sign_bg = vim.api.nvim_get_hl(0, { name = 'SignColumn' }).bg

        -- https://github.com/mfussenegger/nvim-dap/discussions/355
        vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint' })
        vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped' })
        vim.api.nvim_set_hl(0, 'DapBreakpoint', { bg = sign_bg, fg = '#e82424' })
        vim.api.nvim_set_hl(0, 'DapStopped', { bg = sign_bg, fg = '#98bb6c' })

        for type, icon in pairs(lsp_signs) do
            local fg_color = vim.api.nvim_get_hl(0, { name = 'Diagnostic' .. type }).fg

            local sign = 'DiagnosticSign' .. type
            vim.fn.sign_define(sign, { text = icon, texthl = sign, numhl = '' })
            vim.api.nvim_set_hl(0, sign, { bg = sign_bg, fg = fg_color })
        end
    end,
})
