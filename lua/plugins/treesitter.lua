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
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = { query = '@function.outer', desc = 'Select outer part of the function' },
            ['if'] = { query = '@function.inner', desc = 'Select inner part of the function' },
            ['ac'] = { query = '@class.outer', desc = 'Select outer part of the class' },
            ['ic'] = { query = '@class.inner', desc = 'Select innter part of the class' },
          },
        },
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}
