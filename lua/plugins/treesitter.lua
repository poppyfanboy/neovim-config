return {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    ---@type TSConfig
    opts = {
      ensure_installed = { 'lua', 'help' },
      auto_install = false,
      highlight = { enable = true },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}
