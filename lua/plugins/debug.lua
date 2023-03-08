return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      -- FIXME: this is dumb, the actual dependency here is mason, but I have to specify the
      -- lspconfig because I don't install mason as a standalone thing with lazy
      'neovim/nvim-lspconfig',
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'
      local mason = require 'mason-registry'

      if (mason.is_installed('codelldb')) then
        dap.adapters.codelldb = {
          type = 'server',
          port = '${port}',
          executable = {
            -- FIXME: nvim-dap requires the whole path including the .cmd extension on Windows
            command = vim.fn.stdpath 'data' .. '\\mason\\bin\\codelldb' .. (vim.fn.has('win32') and '.cmd' or ''),
            args = { '--port', '${port}' },
            detached = false,
          },
        }

        dap.configurations.rust = {
          {
            name = 'Launch file',
            type = 'codelldb',
            program = function()
              -- TODO: figure out how to concat path segments in a platform independent way

              return vim.fn.input(
                'Path to executable: ',
                vim.fn.getcwd() .. '\\target\\debug\\',
                'file'
              )
            end,
            request = 'launch',
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
          },
        }
        dap.configurations.cpp = dap.configurations.rust
        dap.configurations.c = dap.configurations.rust
      end

      vim.keymap.set('n', '<F5>', dap.continue)
      vim.keymap.set('n', '<F1>', dap.step_into)
      vim.keymap.set('n', '<F2>', dap.step_over)
      vim.keymap.set('n', '<F3>', dap.step_out)
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)
      vim.keymap.set('n', '<leader>B', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end)

      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '',
            play = '▶',
            step_into = '⏎',
            step_over = '',
            step_out = '',
            step_back = 'b',
            run_last = '',
            terminate = '',
          },
        },
      }

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open

      vim.keymap.set('n', '<leader>dt', function()
        dapui.toggle()
      end)
    end
  },
}
