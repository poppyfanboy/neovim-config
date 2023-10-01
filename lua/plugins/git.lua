return {
    {
        'lewis6991/gitsigns.nvim',
        event = { 'VeryLazy' },
        config = function()
            require('gitsigns').setup({
                on_attach = function(buffer)
                    local gitsigns = package.loaded.gitsigns

                    vim.keymap.set('n', ']c', function()
                        if vim.wo.diff then
                            return ']c'
                        end
                        vim.schedule(gitsigns.next_hunk)
                        return '<Ignore>'
                    end, {
                        expr = true,
                        buffer = buffer,
                        desc = 'Go to next hunk',
                    })
                    vim.keymap.set('n', '[c', function()
                        if vim.wo.diff then
                            return '[c'
                        end
                        vim.schedule(gitsigns.prev_hunk)
                        return '<Ignore>'
                    end, {
                        expr = true,
                        buffer = buffer,
                        desc = 'Go to previous hunk',
                    })
                    vim.keymap.set('n', '<leader>hs', gitsigns.stage_hunk, {
                        buffer = buffer,
                        desc = '[h]unk [s]tage',
                    })
                    vim.keymap.set('n', '<leader>hr', gitsigns.reset_hunk, {
                        buffer = buffer,
                        desc = '[h]unk [r]eset',
                    })
                    vim.keymap.set('v', '<leader>hs', function()
                        gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                    end, {
                        buffer = buffer,
                        desc = '[h]unk [s]tage',
                    })
                    vim.keymap.set('v', '<leader>hr', function()
                        gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                    end, {
                        buffer = buffer,
                        desc = '[h]unk [r]eset',
                    })
                    vim.keymap.set('n', '<leader>hS', gitsigns.stage_buffer, {
                        buffer = buffer,
                        desc = 'Stage the whole buffer',
                    })
                    vim.keymap.set('n', '<leader>hu', gitsigns.undo_stage_hunk, {
                        buffer = buffer,
                        desc = '[h]unk [u]ndo stage',
                    })
                    vim.keymap.set('n', '<leader>hR', gitsigns.reset_buffer, {
                        buffer = buffer,
                        desc = 'Reset the whole buffer',
                    })
                    vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk, {
                        buffer = buffer,
                        desc = '[h]unk [p]review',
                    })
                    vim.keymap.set('n', '<leader>hd', gitsigns.diffthis, {
                        buffer = buffer,
                        desc = 'Diff the current file',
                    })
                    vim.keymap.set('n', '<leader>hD', function()
                        gitsigns.diffthis('~')
                    end, {
                        buffer = buffer,
                    })
                    vim.keymap.set('n', '<leader>td', gitsigns.toggle_deleted, {
                        buffer = buffer,
                        desc = '[t]oggle [d]eleted',
                    })
                end,
            })
        end,
    },
    {
        'tpope/vim-fugitive',
        cmd = { 'Git' },
        keys = {
            { '<leader>g', [[<cmd>Git<cr>]], mode = { 'n' }, desc = 'open [g]it (fugitive)' },
        },
    },
    {
        'sindrets/diffview.nvim',
        cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
        keys = {
            {
                '<leader>dvo',
                [[<cmd>DiffviewOpen<cr>]],
                mode = { 'n' },
                desc = '[d]iff [v]iew [o]pen',
            },
            {
                '<leader>dvc',
                [[<cmd>DiffviewClose<cr>]],
                mode = { 'n' },
                desc = '[d]iff [v]iew [c]lose',
            },
            {
                '<leader>dvf',
                [[<cmd>DiffviewFileHistory %<cr>]],
                mode = { 'n' },
                desc = '[d]iff [v]iew [f]ile history',
            },
        },
    },
}
