vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.keymap = 'russian-jcukenwin'
vim.o.langmap = table.concat({
  table.concat({
    'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ',
    'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
  }, ';'),
  table.concat({
    'фисвуапршолдьтщзйкыегмцчня',
    'abcdefghijklmnopqrstuvwxyz',
  }, ';'),
}, ',')
vim.o.iminsert = 0
vim.o.imsearch = -1
vim.keymap.set({ 'i', 'c' }, '<c-l>', '<c-^>', {})
vim.keymap.set({ 'n' }, '<c-l>', 'i<c-^><esc>', {})

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

vim.keymap.set({ 'c' }, '<c-space>', '<c-y>', { silent = true })

vim.keymap.set({ 'n' }, ']q', '<cmd>cnext<cr>', { silent = true })
vim.keymap.set({ 'n' }, '[q', '<cmd>cprev<cr>', { silent = true })
