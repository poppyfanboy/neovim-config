return {
  'gpanders/editorconfig.nvim',
  'tpope/vim-fugitive',
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  {
    'romgrk/barbar.nvim',
    opts = {
      animation = false,
      diagnostics = {
        { enabled = true, icon = ' ' }, -- error
        { enabled = true, icon = ' ' }, -- warn
        { enabled = false }, -- info
        { enabled = false }, -- hint
      },
    },
      config = function(_, opts)
        require('bufferline').setup(opts)

      local keymap_opts = { noremap = true, silent = true }
      vim.api.nvim_set_keymap('n', '<A-p>', '<Cmd>BufferPrevious<cr>', keymap_opts)
      vim.api.nvim_set_keymap('n', '<A-n>', '<Cmd>BufferNext<cr>', keymap_opts)
    end
  },
  {
    'nvim-tree/nvim-tree.lua',
    tag = 'nightly',
    opts = {
      update_focused_file = {
        enable = true,
        update_root = true,
        ignore_list = { 'gitcommit' },
      },
    },
    config = function(_, opts)
      require('nvim-tree').setup(opts)

      vim.keymap.set(
        'n',
        '<leader>et',
        ':NvimTreeToggle<cr>',
        { silent = true, desc = 'File [E]xplorer [T]oggle' }
      )
      vim.keymap.set(
        'n',
        '<leader>ef',
        ':NvimTreeFocus<cr>',
        { silent = true, desc = 'File [E]xplorer [F]ocus' }
      )

      local nvim_tree_events = require('nvim-tree.events')
      local bufferline_api = require('bufferline.api')

      local function get_tree_size()
        return require 'nvim-tree.view'.View.width
      end

      nvim_tree_events.subscribe('TreeOpen', function()
        bufferline_api.set_offset(get_tree_size())
      end)

      nvim_tree_events.subscribe('Resize', function()
        bufferline_api.set_offset(get_tree_size())
      end)

      nvim_tree_events.subscribe('TreeClose', function()
        bufferline_api.set_offset(0)
      end)
    end
  },
}
