vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1

vim.cmd.syntax('manual')

vim.opt.path:append('**')

vim.o.title = true

vim.o.undofile = true
vim.o.backup = false
vim.o.writebackup = false

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 0
vim.o.smartindent = true
vim.o.shiftround = true

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.gdefault = true

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
vim.o.showcmd = true
vim.o.ruler = false
vim.o.pumheight = 10
vim.o.mouse = ''
vim.o.laststatus = 3

vim.o.sidescrolloff = 3

vim.o.updatetime = 250
vim.o.timeoutlen = 400

vim.o.completeopt = 'menu,menuone,noselect'

vim.o.foldmethod = 'manual'
vim.o.foldminlines = 5
vim.o.foldtext = ''

vim.filetype.add({
    extension = {
        vert = 'glsl',
        frag = 'glsl',
        h = 'c',
    },
})

local listchars = {
    eol = '󰘌',
    trail = '_',
    space = '·',
    tab = '-->',
}

vim.o.list = true
for listchar_name, listchar_value in pairs(listchars) do
    vim.opt.listchars:append(string.format('%s:%s', listchar_name, listchar_value))
end

local fillchars = {
    diff = '╱',
    fold = ' ',
}

for fillchar_name, fillchar_value in pairs(fillchars) do
    vim.opt.fillchars:append(string.format('%s:%s', fillchar_name, fillchar_value))
end

if vim.g.neovide then
    vim.o.guifont = 'IosevkaTerm Nerd Font:h12'
    vim.g.neovide_floating_shadow = false
    vim.g.neovide_scroll_animation_length = 0.15
    vim.g.neovide_cursor_animation_length = 0.05
    vim.g.neovide_text_gamma = 0.8
    vim.g.neovide_text_contrast = 0.1
end
