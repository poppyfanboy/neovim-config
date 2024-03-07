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

-- Better keymaps for resizing splits
vim.keymap.set('n', '<Left>', '25<C-w><')
vim.keymap.set('n', '<C-Left>', '8<C-w><')
vim.keymap.set('n', '<Right>', '25<C-w>>')
vim.keymap.set('n', '<C-Right>', '8<C-w>>')
vim.keymap.set('n', '<Up>', '10<C-w>-')
vim.keymap.set('n', '<C-Up>', '4<C-w>-')
vim.keymap.set('n', '<Down>', '10<C-w>+')
vim.keymap.set('n', '<C-Down>', '4<C-w>+')
vim.keymap.set('n', '<C-w><leader>', '<C-w>|<C-w>_')

-- I just can't hit <c-y> consistently
vim.keymap.set('c', '<Right>', '<c-y>')
vim.keymap.set('c', '<Left>', '<c-e>')

-- Delete to void register
vim.keymap.set('v', '<leader>d', '"_d')
vim.keymap.set('v', '<leader>c', '"_c')
vim.keymap.set('n', '<leader>C', '"_C')

-- Exit terminal mode more easily
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Quit without saving
vim.keymap.set({ 'n' }, '<leader>qa', '<cmd>qa!<cr>', {
    desc = '[q]uit [a]ll without saving',
})

-- Hide highlighted words after searching
vim.keymap.set({ 'n' }, '<leader>nh', '<cmd>nohlsearch<cr>', {
    desc = '[n]o [h]ighlight',
})

-- Tab keymaps
vim.keymap.set({ 'n' }, '<leader>tn', [[<cmd>tabnew<cr>]], { desc = '[t]ab [n]ew' })
vim.keymap.set({ 'n' }, '<leader>tc', [[<cmd>tabclose<cr>]], { desc = '[t]ab [c]lose' })
vim.keymap.set({ 'n' }, '[t', [[<cmd>tabprevious<cr>]], { desc = 'Previous tab' })
vim.keymap.set({ 'n' }, ']t', [[<cmd>tabnext<cr>]], { desc = 'Next tab' })

-- Switch between Russian and English keymaps
vim.keymap.set({ 'n' }, '<c-l>', function()
    if vim.o.iminsert == 1 then
        vim.o.iminsert = 0
    else
        vim.o.iminsert = 1
    end

    require('util').refresh_statusline()
end)
vim.keymap.set({ 'i', 'c' }, '<c-l>', [[<c-^><cmd>lua require('util').refresh_statusline()<cr>]])

-- Chooses the first option when correcting a spelling mistake
vim.keymap.set({ 'n' }, '<leader>z', '1z=')

-- Auto-fix (choose the first option) the last spelling mistake while typing in insert mode
-- https://stackoverflow.com/a/16481737
vim.keymap.set({ 'i' }, '<c-f>', '<c-g>u<Esc>[s1z=`]a<c-g>u')

-- Scroll by a third of the screen height instead of 50% + keep the cursor in the middle of the
-- screen
vim.keymap.set({ 'n' }, '<C-u>', function()
    local height = math.floor(vim.fn.winheight(0) / 3)
    vim.cmd(
        'keepjumps norm!' .. vim.api.nvim_replace_termcodes(height .. '<C-y>M', true, true, true)
    )
end)
vim.keymap.set({ 'n' }, '<C-d>', function()
    local height = math.floor(vim.fn.winheight(0) / 3)
    vim.cmd(
        'keepjumps norm!' .. vim.api.nvim_replace_termcodes(height .. '<C-e>M', true, true, true)
    )
end)

-- Center current line on screen while typing
vim.keymap.set({ 'i' }, '<C-z>', '<C-o>zz')

-- Move horizontally in normal/insert modes
vim.keymap.set({ 'n' }, '<a-h>', '15zh')
vim.keymap.set({ 'n' }, '<a-l>', '15zl')
vim.keymap.set({ 'i' }, '<a-h>', '<c-o>15zh')
vim.keymap.set({ 'i' }, '<a-l>', '<c-o>15zl')

-- Quickfix keymaps
vim.keymap.set({ 'n' }, '<leader>co', '<cmd>copen<cr>', {
    desc = 'Open quickfix list ([c][o]pen)',
})
vim.keymap.set({ 'n' }, '<leader>cx', '<cmd>cclose<cr>', {
    desc = 'Close quickfix list',
})
vim.keymap.set({ 'n' }, ']q', '<cmd>cnext<cr>', {
    silent = true,
    desc = 'Go to next quickfix list entry',
})
vim.keymap.set({ 'n' }, '[q', '<cmd>cprev<cr>', {
    silent = true,
    desc = 'Go to previous quickfix list entry',
})

-- LSP diagnostics
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

-- Move lines and blocks of code up or down
vim.keymap.set({ 'v' }, '<a-j>', [[:m '>+1<cr>gv=gv]])
vim.keymap.set({ 'v' }, '<a-k>', [[:m '<-2<cr>gv=gv]])
vim.keymap.set({ 'n' }, '<a-j>', [[:m .+1<cr>==]])
vim.keymap.set({ 'n' }, '<a-k>', [[:m .-2<cr>==]])

-- Join line while keeping the cursor in the same position
vim.keymap.set('n', 'J', 'mzJ`z')

-- Go to previous file
vim.keymap.set({ 'n' }, '\\', '<c-^>')

-- Indent multiple times in visual mode more easily
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true })

-- Replace a word under the cursor (dot-repeatable)
vim.keymap.set('n', '<leader>rw', '*``cgn', { desc = '[r]eplace a [w]ord under the cursor' })
