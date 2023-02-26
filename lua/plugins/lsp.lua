return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      {
        'j-hui/fidget.nvim',
        opts = {},
      },
      {
        'folke/neodev.nvim',
        opts = {},
      },
    },
    opts = {
      servers = {
        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      },
    },
    config = function(_, opts)
      require('neodev').setup()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      local on_attach = function(_, bufnr)
        local map = function(modes, keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end

          vim.keymap.set(modes, keys, func, { buffer = bufnr, desc = desc })
        end

        -- TODO: add more LSP mappings
        map('n', 'gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        map({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help, 'Signature help')

        vim.api.nvim_buf_create_user_command(
          bufnr,
          'Format',
          function(_)
            vim.lsp.buf.format()
          end,
          { desc = 'Format current buffer with LSP' }
        )
      end

      require('mason').setup()
      local mason_lspconfig = require 'mason-lspconfig'
      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(opts.servers),
      }
      mason_lspconfig.setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            settings = opts.servers[server_name],
            on_attach = on_attach,
          }
        end,
      }
    end,
  },
}
