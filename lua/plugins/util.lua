return {
  {
    'iamcco/markdown-preview.nvim',
    build = function()
      vim.fn['mkdp#util#install']()
    end
  },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
      end

      vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')

      vim.keymap.set(
        { 'n' },
        '<leader>tt',
        [[<C-\><C-n>:ToggleTermToggleAll<cr>]],
        { desc = 'Toggle all terminals', silent = true }
      )
      vim.keymap.set(
        { 'n' },
        '<leader>t1',
        [[<C-\><C-n>:ToggleTerm 1<cr>]],
        { desc = 'Open first terminal', silent = true }
      )
      vim.keymap.set(
        { 'n' },
        '<leader>t2',
        [[<C-\><C-n>:ToggleTerm 2<cr>]],
        { desc = 'Open second terminal', silent = true }
      )
      vim.keymap.set(
        { 'n' },
        '<leader>tf',
        [[<C-\><C-n>:ToggleTerm 3 direction=float<cr>]],
        { desc = 'Open floating terminal', silent = true }
      )

      require('toggleterm').setup()
    end
  },
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('todo-comments').setup({})
    end,
  },
  'kevinhwang91/nvim-bqf',
}
