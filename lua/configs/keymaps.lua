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
  vim.keymap.set('n', '<leader>fs', function()
    vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
  end)
end

vim.keymap.set({ 'n' }, ']q', '<cmd>cnext<cr>', { silent = true })
vim.keymap.set({ 'n' }, '[q', '<cmd>cprev<cr>', { silent = true })

vim.keymap.set({ 'n' }, '<leader>qa', '<cmd>qa!<cr>')
