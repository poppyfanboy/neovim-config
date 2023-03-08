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
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true})

        map('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true})

        map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
        map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
        map('n', '<leader>hu', gs.undo_stage_hunk)
        map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>hd', gs.diffthis)
        map('n', '<leader>td', gs.toggle_deleted)
      end
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
      vim.api.nvim_set_keymap('n', '<A-c>c', '<Cmd>BufferClose<cr>', keymap_opts)
      vim.api.nvim_set_keymap('n', '<A-c>C', '<Cmd>BufferClose!<cr>', keymap_opts)
      vim.api.nvim_set_keymap('n', '<A-c>h', '<Cmd>BufferCloseBuffersLeft<cr>', keymap_opts)
      vim.api.nvim_set_keymap('n', '<A-c>l', '<Cmd>BufferCloseBuffersRight<cr>', keymap_opts)
      vim.api.nvim_set_keymap('n', '<leader>bp', '<cmd>BufferPick<cr>', keymap_opts)
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    tag = 'nightly',
    opts = {
      sync_root_with_cwd = true,
      renderer = {
        root_folder_label = ':t',
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
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = table.concat({
      'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release',
      'cmake --build build --config Release',
      'cmake --install build --prefix build',
    }, ' && ')
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
        },
      },
      defaults = {
        mappings = {
          i = {
            ['<c-l>'] = { '<c-^>', type = 'command' },
          },
        },
      },
    },
    config = function(_, opts)
      local telescope = require 'telescope';
      telescope.setup(opts)
      telescope.load_extension('fzf')

      vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
      vim.keymap.set('n', '<leader>fhf', '<cmd>Telescope find_files hidden=true<cr>')
      vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
      vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
      vim.keymap.set('n', '<leader>fc', '<cmd>Telescope command_history<cr>')
    end,
  },
}
