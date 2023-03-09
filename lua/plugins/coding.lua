return {
  {
    'numToStr/Comment.nvim',
    config = true,
  },
  {
    -- 'kylechui/nvim-surround' acts weird from time to time
    'tpope/vim-surround',
    dependencies = { 'tpope/vim-repeat' },
  },
  {
    'windwp/nvim-autopairs',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function ()
      require('nvim-autopairs').setup({ check_ts = true })

      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end,
  },
  {
    'ggandor/leap.nvim',
    config = function ()
      require('leap').add_default_mappings()
    end
  },
}
