vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

if vim.g.neovide then
  vim.api.nvim_set_keymap(
    'n',
    '<leader>fs',
    ':lua vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen<cr>',
    { silent = true, desc = 'Toggle [F]ull[S]creen' }
  )
end

vim.api.nvim_set_keymap(
  'n',
  '<leader>cd',
  ':lcd %:p:h<cr>',
  { silent = true, desc = '[C]hange [D]irectory to opened file' }
)
