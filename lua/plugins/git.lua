local common = require('common')

return {
    {
        'lewis6991/gitsigns.nvim',
        event = 'LazyFile',
        config = function()
            --- @type number?
            local diff_window_id = nil

            vim.keymap.set('n', '<leader>hD', function()
                if diff_window_id ~= nil then
                    vim.api.nvim_win_close(diff_window_id, true)
                    diff_window_id = nil
                end
                common.toggle_winbar(true)
            end, {
                desc = 'Close the diff of the current file',
            })

            require('gitsigns').setup({
                preview_config = {
                    border = 'none',
                },
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
                    vim.keymap.set('n', '<leader>hd', function()
                        common.toggle_winbar(false)
                        gitsigns.diffthis()
                        vim.cmd.wincmd('p')
                        diff_window_id = vim.fn.win_getid()
                        vim.cmd.wincmd('p')
                    end, {
                        buffer = buffer,
                        desc = 'Diff the current file',
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
            {
                '<leader>g',
                function()
                    vim.cmd('Git')
                end,
                mode = 'n',
                desc = 'open [g]it (fugitive)',
            },
        },
    },
    {
        'sindrets/diffview.nvim',
        cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
        keys = {
            {
                '<leader>dvo',
                function()
                    common.toggle_winbar(false)
                    vim.cmd('DiffviewOpen')
                end,
                mode = 'n',
                desc = '[d]iff [v]iew [o]pen',
            },
            {
                '<leader>dvc',
                function()
                    vim.cmd('DiffviewClose')
                    common.toggle_winbar(true)
                end,
                mode = 'n',
                desc = '[d]iff [v]iew [c]lose',
            },
            {
                '<leader>dvf',
                function()
                    common.toggle_winbar(false)
                    vim.cmd('DiffviewFileHistory %')
                end,
                mode = 'n',
                desc = '[d]iff [v]iew [f]ile history',
            },
        },
    },
}
