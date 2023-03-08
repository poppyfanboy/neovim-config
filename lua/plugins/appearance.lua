return {
  {
    'lukas-reineke/indent-blankline.nvim',
    opts = function()
      local opts = {
        context_char = '▏',
        show_current_context = true,
        show_current_context_start = false,
        show_end_of_line = true,
        use_treesitter = true,
      }

      -- this option looks janky in terminal emulators
      if (vim.g.neovide) then
        opts.show_current_context_start = true
      end

      return opts
    end
  },
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
          return '⌨ ' .. vim.b['keymap_name']
        end
        return ''
      end

      require('lualine').setup({
        options = {
          disabled_filetypes = { 'NvimTree' },
        },
        sections = {
          lualine_a = { 'mode', keymap },
        },
      })
    end,
  },
}
