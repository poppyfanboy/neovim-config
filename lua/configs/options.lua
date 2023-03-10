vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.smartindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4

vim.o.sidescrolloff = 4

vim.o.fileformat = 'unix'
vim.o.fixendofline = true

vim.o.textwidth = 100

vim.o.timeout = true
vim.o.timeoutlen = 400
vim.o.updatetime = 350

vim.o.formatoptions = 'jcrqlnto'

vim.g.python3_host_prog = 'python'
vim.g.zip_zipcmd = os.getenv('ZIP_COMMAND') or 'zip'
vim.g.zip_unzipcmd = os.getenv('UNZIP_COMMAND') or 'unzip'

if vim.g.neovide then
  vim.g.neovide_confirm_quit = false
end
