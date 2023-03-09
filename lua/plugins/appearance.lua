return {
  {
    'folke/tokyonight.nvim',
    config = function()
      vim.cmd.colorscheme('tokyonight')
      vim.cmd [[ highlight MatchParen ctermbg=209 guibg=#ff875f ctermfg=23 guifg=#005f5f ]]
    end,
    -- high priority is recommended for colorscheme plugins (the default is 50)
    priority = 1000,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      local function keymap()
        if vim.opt.iminsert:get() > 0 and vim.b['keymap_name'] then
          return '󰥻 ' .. vim.b['keymap_name']
        end
        return ''
      end

      require('lualine').setup({
        options = {
          disabled_filetypes = {
            'netrw',
          },
        },
        sections = {
          lualine_a = { 'mode', keymap },
        },
      })
    end,
  },
}
