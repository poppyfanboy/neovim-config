vim.o.relativenumber = true
vim.o.number = true
vim.o.signcolumn = 'yes'
vim.o.showtabline = 2
vim.o.showmode = false

vim.o.cursorline = true
vim.o.colorcolumn = '100'

vim.o.wrap = false

vim.o.pumheight = 10

vim.o.list = true
vim.o.listchars = 'eol:󱞦,trail:_,space:·'

if vim.g.neovide then
  vim.g.neovide_hide_mouse_when_typing = true
  vim.o.guifont = 'CaskaydiaCove NFM:h13'
end
