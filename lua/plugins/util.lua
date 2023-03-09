return {
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
        '<leader>tf',
        [[<C-\><C-n>:ToggleTerm 3 direction=float<cr>]],
        { desc = 'Open floating terminal', silent = true }
      )

      require('toggleterm').setup()
    end
  },
}
