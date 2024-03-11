local common = require('common')

local opts = { noremap = true, silent = true }
local function opts_desc(desc)
    return {
        noremap = true,
        silent = true,
        desc = desc,
    }
end

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', opts)

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
vim.keymap.set('n', '<Left>', '25<C-w><', opts)
vim.keymap.set('n', '<C-Left>', '8<C-w><', opts)
vim.keymap.set('n', '<Right>', '25<C-w>>', opts)
vim.keymap.set('n', '<C-Right>', '8<C-w>>', opts)
vim.keymap.set('n', '<Up>', '10<C-w>-', opts)
vim.keymap.set('n', '<C-Up>', '4<C-w>-', opts)
vim.keymap.set('n', '<Down>', '10<C-w>+', opts)
vim.keymap.set('n', '<C-Down>', '4<C-w>+', opts)
vim.keymap.set('n', '<C-w><leader>', '<C-w>|<C-w>_', opts)

-- I just can't hit <C-y> consistently
vim.keymap.set('c', '<Right>', '<C-y>', opts)
vim.keymap.set('c', '<Left>', '<C-e>', opts)
vim.keymap.set('c', '<A-l>', '<Right>', { silent = false, noremap = true })
vim.keymap.set('c', '<A-h>', '<Left>', { silent = false, noremap = true })

-- Delete to void register
vim.keymap.set('v', '<leader>d', '"_d', opts)
vim.keymap.set('v', '<leader>c', '"_c', opts)
vim.keymap.set('n', '<leader>C', '"_C', opts)

-- Exit terminal mode more easily
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', opts_desc('Exit terminal mode'))

-- Quit without saving
vim.keymap.set('n', '<leader>qa', function()
    vim.cmd.qa({ bang = true })
end, opts_desc('[q]uit [a]ll without saving'))

-- Hide highlighted words after searching
vim.keymap.set('n', '<leader>nh', vim.cmd.nohlsearch, opts_desc('[n]o [h]ighlight'))

-- Tab keymaps
vim.keymap.set('n', '<leader>tn', vim.cmd.tabnew, opts_desc('[t]ab [n]ew'))
vim.keymap.set('n', '<leader>tc', vim.cmd.tabclose, opts_desc('[t]ab [c]lose'))
vim.keymap.set('n', '[t', vim.cmd.tabprevious, opts_desc('Previous tab'))
vim.keymap.set('n', ']t', vim.cmd.tabnext, opts_desc('Next tab'))

-- Switch between Russian and English keymaps
vim.keymap.set('n', '<C-l>', function()
    if vim.o.iminsert == 1 then
        vim.o.iminsert = 0
    else
        vim.o.iminsert = 1
    end

    common.refresh_statusline()
end, opts)

vim.keymap.set({ 'i', 'c' }, '<C-l>', function()
    vim.api.nvim_input('<C-^>')

    if vim.o.iminsert == 1 then
        vim.o.iminsert = 0
    else
        vim.o.iminsert = 1
    end

    common.refresh_statusline()
end, opts)

-- Chooses the first option when correcting a spelling mistake
vim.keymap.set('n', '<leader>z', '1z=', opts)

-- Auto-fix (choose the first option) the last spelling mistake while typing in insert mode
-- https://stackoverflow.com/a/16481737
vim.keymap.set('i', '<C-f>', '<C-g>u<Esc>[s1z=`]a<C-g>u', opts)

-- Scroll by a third of the screen height instead of 50% + keep the cursor in the middle of the
-- screen
vim.keymap.set('n', '<C-u>', function()
    local height = math.floor(vim.o.lines / 3)
    vim.cmd.norm({
        args = { vim.api.nvim_replace_termcodes(height .. '<C-y>M', true, true, true) },
        bang = true,
    })
end, opts)
vim.keymap.set('n', '<C-d>', function()
    local height = math.floor(vim.o.lines / 3)
    vim.cmd.norm({
        args = { vim.api.nvim_replace_termcodes(height .. '<C-e>M', true, true, true) },
        bang = true,
    })
end, opts)

vim.keymap.set('n', '<C-e>', '4<C-e>', opts)
vim.keymap.set('n', '<C-y>', '4<C-y>', opts)

-- Center current line on screen while typing
vim.keymap.set('i', '<C-z>', '<C-o>zz', opts)

-- Move horizontally in normal/insert modes
vim.keymap.set('n', '<a-h>', '15zh', opts)
vim.keymap.set('n', '<a-l>', '15zl', opts)
vim.keymap.set('i', '<a-h>', '<C-o>15zh', opts)
vim.keymap.set('i', '<a-l>', '<C-o>15zl', opts)

-- Quickfix keymaps
vim.keymap.set('n', '<leader>co', vim.cmd.copen, opts_desc('Open quickfix list'))
vim.keymap.set('n', '<leader>cx', vim.cmd.cclose, opts_desc('Close quickfix list'))

vim.keymap.set('n', ']q', function()
    local ok, _ = pcall(vim.cmd.cnext)
    if not ok then
        pcall(vim.cmd.cfirst)
    end
end, opts_desc('Go to next quickfix list entry'))

vim.keymap.set('n', '[q', function()
    local ok, _ = pcall(vim.cmd.cprevious)
    if not ok then
        pcall(vim.cmd.clast)
    end
end, opts_desc('Go to previous quickfix list entry'))

-- LSP diagnostics
vim.keymap.set('n', '<leader>dt', function()
    local config = vim.diagnostic.config()
    if config == nil then
        return
    end

    local diagnostics_enabled = type(config.signs) == 'table' or config.underline

    vim.diagnostic.config({
        underline = not diagnostics_enabled,
        signs = (not diagnostics_enabled) and common.diagnostic_signs or false,
    })
end, opts_desc('[d]iagnostics [t]oggle'))

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts_desc('Go to previous diagnostic message'))
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts_desc('Go to next diagnostic message'))
vim.keymap.set('n', '<leader>dp', vim.diagnostic.open_float, opts_desc('[d]iagnostic [p]review'))

-- Move lines and blocks of code up or down
vim.keymap.set('v', '<a-j>', "<cmd>m '>+1<cr> gv=gv", opts)
vim.keymap.set('v', '<a-k>', "<cmd>m '<-2<cr> gv=gv", opts)
vim.keymap.set('n', '<a-j>', '<cmd>m .+1<cr> ==', opts)
vim.keymap.set('n', '<a-k>', '<cmd>m .-2<cr> ==', opts)

-- Join line while keeping the cursor in the same position
vim.keymap.set('n', 'J', 'mzJ`z', opts)

-- Go to previous file
vim.keymap.set('n', '\\', '<C-^>', opts)

-- Indent multiple times in visual mode more easily
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Replace a word under the cursor (dot-repeatable)
vim.keymap.set('n', '<leader>rw', '*``cgn', opts_desc('[r]eplace a [w]ord under the cursor'))
vim.keymap.set(
    'v',
    '<leader>rw',
    '"zy/<C-r>z<cr>``cgn',
    opts_desc('[r]eplace a [w]ord under the cursor')
)

-- Move through words in camelCased identifiers
vim.keymap.set('n', '<a-.>', '/\\v(\\u|.>|<)<cr><cmd>nohls<cr>', opts)
vim.keymap.set('n', '<a-,>', '?\\v(\\u|.<|>)<cr><cmd>nohls<cr>', opts)
vim.keymap.set('v', '<a-.>', '<Esc>/\\v(\\u|.>|<)<cr><cmd>nohls<cr>mzgv`z', opts)
vim.keymap.set('v', '<a-,>', '<Esc>?\\v(\\u|.<|>)<cr><cmd>nohls<cr>mzgv`z', opts)

-- Move though words in snake_cased identifiers
vim.keymap.set('n', '<a-n>', '/\\v(_|..>|.<|$)/s+1<cr><cmd>nohls<cr>', opts)
vim.keymap.set('n', '<a-p>', '?\\v(_|.<|.>|$)?s+1<cr><cmd>nohls<cr>', opts)
vim.keymap.set('v', '<a-n>', '<Esc>/\\v(_|..>|.<|$)/s+1<cr><cmd>nohls<cr>mzgv`z', opts)
vim.keymap.set('v', '<a-p>', '<Esc>?\\v(_|.<|.>|$)?s+1<cr><cmd>nohls<cr>mzgv`z', opts)

-- Add a blank line above or below the current one without moving the cursor
vim.keymap.set('n', '[<Space>', 'mzO<Esc>0D`z', opts)
vim.keymap.set('n', ']<Space>', 'mzo<Esc>0D`z', opts)
