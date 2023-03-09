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
    'ggandor/leap.nvim',
    config = function ()
      require('leap').add_default_mappings()
    end
  },
}
