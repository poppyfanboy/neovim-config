return {
    {
        'sakhnik/nvim-gdb',
        cmd = { 'GdbStart', 'GdbStartLLDB' },
    },
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            'rcarriga/nvim-dap-ui',
            'williamboman/mason.nvim',
            'jay-babu/mason-nvim-dap.nvim',
        },
        keys = {
            {
                '<leader>db',
                function()
                    require('dap').toggle_breakpoint()
                end,
                desc = '[d]ebug [b]reakpoint',
            },
            {
                '<leader>dc',
                function()
                    require('dap').continue()
                end,
                desc = '[d]ebug [c]ontinue',
            },
            {
                '<leader>dC',
                function()
                    require('dap').run_to_cursor()
                end,
                desc = '[d]ebug [C]ontinue to cursor',
            },
            {
                '<leader>di',
                function()
                    require('dap').step_into()
                end,
                desc = '[d]ebug step [i]nto',
            },
            {
                '<leader>do',
                function()
                    require('dap').step_over()
                end,
                desc = '[d]ebug step [o]ver',
            },
            {
                '<leader>dO',
                function()
                    require('dap').step_out()
                end,
                desc = '[d]ebug step [O]ut',
            },
            {
                '<leader>dd',
                function()
                    require('dapui').toggle()
                end,
                desc = 'Toggle DAP UI',
            },
            {
                '<leader>dP',
                function()
                    require('dap').pause()
                end,
                desc = '[d]ebug [P]ause',
            },
            {
                '<leader>dh',
                function()
                    require('dap.ui.widgets').hover()
                end,
                desc = '[d]ebug [h]over',
            },
        },
        config = function()
            local dap = require('dap')
            local dapui = require('dapui')

            require('mason-nvim-dap').setup({
                automatic_installation = false,
                handlers = {},
                ensure_installed = {
                    'codelldb',
                },
            })

            dap.configurations.rust = {
                {
                    name = 'Launch',
                    type = 'codelldb',
                    request = 'launch',
                    program = function()
                        return vim.fn.input({
                            propmpt = 'Path to executable: ',
                            default = vim.fn.getcwd() .. require('util').path_separator,
                            completion = 'file',
                        })
                    end,
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                    args = {},
                    runInTerminal = false,
                    initCommands = function()
                        local rustc_sysroot = vim.fn.trim(vim.fn.system('rustc --print sysroot'))
                        rustc_sysroot = string.gsub(rustc_sysroot, '\\', '/')

                        local rust_hash = vim.fn.trim(vim.fn.system('rustc -vV'))
                        rust_hash = string.match(rust_hash, 'commit%-hash: (%w+)')

                        local source_map_command = string.format(
                            'settings set target.source-map /rustc/%s %s/lib/rustlib/src/rust',
                            rust_hash,
                            rustc_sysroot
                        )

                        return {
                            source_map_command,
                        }
                    end,
                },
            }

            --- @diagnostic disable-next-line: missing-fields
            dapui.setup({
                --- @diagnostic disable-next-line: missing-fields
                controls = { enabled = false },
                layouts = {
                    {
                        elements = { 'repl', 'console' },
                        size = 0.4,
                        position = 'bottom',
                    },
                },
            })
            dap.listeners.after.event_initialized['dapui_config'] = dapui.open
            dap.listeners.before.event_terminated['dapui_config'] = dapui.close
            dap.listeners.before.event_exited['dapui_config'] = dapui.close
        end,
    },
}
