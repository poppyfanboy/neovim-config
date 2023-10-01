vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1

vim.opt.path:append('**')

vim.o.title = true

vim.o.undofile = true

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 0
vim.o.smartindent = true
vim.o.shiftround = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.relativenumber = true
vim.o.number = true
vim.o.cursorline = true

vim.o.colorcolumn = '100'
vim.o.textwidth = 100
vim.o.wrap = false
vim.o.formatoptions = 'jcrqlnto'

vim.o.fileformat = 'unix'
vim.opt.fileformats = { 'unix', 'dos' }

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.signcolumn = 'yes'
vim.o.showmode = false
vim.o.pumheight = 10
vim.o.mouse = ''

vim.o.sidescrolloff = 3

vim.o.spell = true
vim.opt.spelllang = { 'en_us', 'ru' }

vim.o.updatetime = 200
