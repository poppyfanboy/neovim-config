if vim.fn.has('win32') == 1 then
    local util = require('util')

    util.use_cmd_terminal()

    if vim.fn.executable('pwsh') == 1 then
        vim.api.nvim_create_user_command('Powershell', function()
            util.use_powershell_terminal()
        end, {})
    end

    vim.api.nvim_create_user_command('Cmd', function()
        util.use_cmd_terminal()
    end, {})
end

vim.api.nvim_create_autocmd({ 'TermOpen' }, {
    callback = function()
        vim.wo.spell = false
    end,
})
