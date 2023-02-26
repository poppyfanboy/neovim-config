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
    config = function()
      local function keymap()
        if vim.opt.iminsert:get() > 0 and vim.b['keymap_name'] then
          return '⌨ ' .. vim.b['keymap_name']
        end
        return ''
      end

      require('lualine').setup({
        sections = {
          lualine_a = { 'mode', keymap },
        },
        extensions = { 'nvim-tree' },
      })
    end,
  },
}
