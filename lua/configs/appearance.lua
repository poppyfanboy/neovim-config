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
vim.opt.listchars:append('eol:󱞦')
vim.opt.listchars:append('trail:_')
vim.opt.listchars:append('space:·')
vim.opt.listchars:append('tab:-->')

vim.o.termguicolors = true
vim.o.guifont = 'CaskaydiaCove NFM:h14'

vim.g.netrw_banner = false

if vim.g.neovide then
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_no_idle = true
end
