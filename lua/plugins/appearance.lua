return {
  {
    'folke/tokyonight.nvim',
    config = function()
      vim.cmd.colorscheme('tokyonight')
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    opts = {
      extensions = { 'nvim-tree' },
    },
  },
}
