vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

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

vim.keymap.set({ 'n' }, '<c-l>', function()
    if vim.o.iminsert == 1 then
        vim.o.iminsert = 0
    else
        vim.o.iminsert = 1
    end

    require('util').refresh_statusline()
end)
vim.keymap.set({ 'i', 'c' }, '<c-l>', [[<c-^><cmd>lua require('util').refresh_statusline()<cr>]])

vim.keymap.set({ 'n' }, '<leader>qa', '<cmd>qa!<cr>', {
    desc = '[q]uit [a]ll without saving',
})
vim.keymap.set({ 'n' }, '<leader>nh', '<cmd>nohlsearch<cr>', {
    desc = '[n]o [h]ighlight',
})

vim.keymap.set({ 'n' }, '<leader>z', '1z=')
-- auto-fix the last spelling mistake while typing in insert mode
-- https://stackoverflow.com/a/16481737
vim.keymap.set({ 'i' }, '<c-f>', '<c-g>u<Esc>[s1z=`]a<c-g>u')

vim.keymap.set({ 'i' }, '<C-z>', '<C-o>zz')
vim.keymap.set({ 'n' }, '<C-u>', function()
    local height = math.floor(vim.fn.winheight(0) / 4)
    vim.cmd.normal(vim.api.nvim_replace_termcodes(height .. '<C-y>M', true, true, true))
end)
vim.keymap.set({ 'n' }, '<C-d>', function()
    local height = math.floor(vim.fn.winheight(0) / 4)
    vim.cmd.normal(vim.api.nvim_replace_termcodes(height .. '<C-e>M', true, true, true))
end)

vim.keymap.set({ 'n' }, '<leader>co', '<cmd>copen<cr>', {
    desc = 'Open quickfix list ([c][o]pen)',
})
vim.keymap.set({ 'n' }, '<leader>cc', '<cmd>cclose<cr>', {
    desc = 'Close quickfix list ([c][c]lose)',
})
vim.keymap.set({ 'n' }, ']q', '<cmd>cnext<cr>', {
    silent = true,
    desc = 'Go to next quickfix list entry',
})
vim.keymap.set({ 'n' }, '[q', '<cmd>cprev<cr>', {
    silent = true,
    desc = 'Go to previous quickfix list entry',
})

vim.keymap.set({ 'n' }, '<leader>dt', function()
    local config = vim.diagnostic.config()
    local diagnostics_enabled = config.signs or config.underline

    vim.diagnostic.config({
        underline = not diagnostics_enabled,
        signs = not diagnostics_enabled,
    })
end, { desc = '[d]iagnostics [t]oggle' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>dp', vim.diagnostic.open_float, { desc = '[d]iagnostic [p]review' })

vim.keymap.set({ 'n' }, '<leader>tn', [[<cmd>tabnew<cr>]], { desc = '[t]ab [n]ew' })

vim.keymap.set({ 'v' }, '<a-j>', [[:m '>+1<cr>gv=gv]])
vim.keymap.set({ 'v' }, '<a-k>', [[:m '<-2<cr>gv=gv]])
vim.keymap.set({ 'n' }, '<a-j>', [[:m .+1<cr>==]])
vim.keymap.set({ 'n' }, '<a-k>', [[:m .-2<cr>==]])
