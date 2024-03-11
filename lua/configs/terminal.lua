if vim.fn.has('win32') == 1 then
    local function use_powershell_terminal()
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
        vim.o.shellslash = false
    end

    local function use_cmd_terminal()
        vim.o.shell = 'cmd.exe'
        vim.o.shellcmdflag = '/s /c'
        vim.o.shellredir = '>'
        vim.o.shellpipe = '>'
        vim.o.shellquote = ''
        vim.o.shellxquote = '"'
        vim.o.shellslash = false
    end

    local function set_bash_shell_options()
        vim.o.shellcmdflag = '-c'
        vim.o.shellredir = '>'
        vim.o.shellpipe = '>'
        vim.o.shellquote = ''
        vim.o.shellxquote = ''
        vim.o.shellslash = true
    end

    use_cmd_terminal()

    if vim.fn.executable('pwsh') == 1 then
        vim.api.nvim_create_user_command('Powershell', function()
            use_powershell_terminal()
        end, {})
    end

    if vim.fn.executable('cmd') == 1 then
        vim.api.nvim_create_user_command('Cmd', function()
            use_cmd_terminal()
        end, {})
    end

    if vim.fn.filereadable('C:\\msys64\\msys2_shell.cmd') then
        vim.api.nvim_create_user_command('MSYS2', function()
            vim.o.shell = 'C:/msys64/msys2_shell.cmd -defterm -here -no-start -ucrt64'
            set_bash_shell_options()
        end, {})
    end

    if vim.fn.executable('wsl') == 1 then
        vim.api.nvim_create_user_command('WSL', function()
            vim.o.shell = 'wsl.exe bash'
            set_bash_shell_options()
        end, {})
    end
end

vim.api.nvim_create_autocmd({ 'TermOpen' }, {
    callback = function()
        vim.wo.spell = false
    end,
})
