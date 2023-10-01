local M = {}

M.large_file_lines_count = 5000

M.path_separator = '/'
if vim.fn.has('win32') == 1 then
    M.path_separator = '\\'
end

function M.refresh_statusline()
    local ok, lualine = pcall(require, 'lualine')
    if ok then
        lualine.refresh()
    end
end

function M.use_powershell_terminal()
    vim.o.shell = 'pwsh'

    -- https://github.com/LunarVim/LunarVim/blob/master/utils/installer/config_win.example.lua
    vim.o.shellcmdflag = table.concat({
        '-NoLogo',
        '-NoProfile',
        '-ExecutionPolicy RemoteSigned',
        '-Command',
        table.concat({
            '[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;',
            -- vim does not support ANSI escape codes for !-commands
            "$PSStyle.OutputRendering='PlainText';",
        }),
    }, ' ')
    vim.o.shellredir = table.concat({
        '2>&1 | Out-File -Encoding UTF8 %s;',
        'exit $LastExitCode;',
    })
    vim.o.shellpipe = table.concat({
        '2>&1 | Out-File -Encoding UTF8 %s;',
        'exit $LastExitCode;',
    })
    vim.o.shellquote = ''
    vim.o.shellxquote = ''
end

function M.use_cmd_terminal()
    vim.o.shell = 'cmd.exe'
    vim.o.shellcmdflag = '/s /c'
    vim.o.shellredir = '>'
    vim.o.shellpipe = '>'
    vim.o.shellquote = ''
    vim.o.shellxquote = '"'
end

return M
