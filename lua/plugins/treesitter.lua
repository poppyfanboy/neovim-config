local function disable_treesitter()
    return vim.b['too_large_for_treesitter']
end

return {
    {
        'nvim-treesitter/nvim-treesitter',
        event = 'LazyFile',
        -- https://github.com/LazyVim/LazyVim/blob/78e6405f90eeb76fdf8f1a51f9b8a81d2647a698/lua/lazyvim/plugins/treesitter.lua#L11
        init = function(plugin)
            require('lazy.core.loader').add_to_rtp(plugin)
            require('nvim-treesitter.query_predicates')
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall', 'TSUninstall' },
        keys = {
            { '<bs>' },
            { '<leader><bs>' },
        },
        config = function()
            --- @diagnostic disable-next-line: missing-fields
            require('nvim-treesitter.configs').setup({
                ensure_installed = {},
                auto_install = false,
                highlight = {
                    enable = true,
                    disable = disable_treesitter,
                },
                matchup = {
                    enable = true,
                    enable_quotes = true,
                    disable = function(language)
                        return language == 'haskell' or disable_treesitter()
                    end,
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ['aa'] = '@parameter.outer',
                            ['ia'] = '@parameter.inner',
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                            ['ac'] = '@class.outer',
                            ['ic'] = '@class.inner',
                            ['ij'] = { query = '@block.outer' },
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = false,
                        goto_next_start = {
                            [']f'] = '@function.outer',
                            [']]'] = '@class.outer',
                            [']a'] = '@parameter.outer',
                        },
                        goto_next_end = {
                            [']F'] = '@function.outer',
                            [']['] = '@class.outer',
                            [']A'] = '@parameter.outer',
                        },
                        goto_previous_start = {
                            ['[f'] = '@function.outer',
                            ['[['] = '@class.outer',
                            ['[a'] = '@parameter.outer',
                        },
                        goto_previous_end = {
                            ['[F'] = '@function.outer',
                            ['[]'] = '@class.outer',
                            ['[A'] = '@parameter.outer',
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ['<leader>j'] = '@parameter.inner',
                        },
                        swap_previous = {
                            ['<leader>k'] = '@parameter.inner',
                        },
                    },
                },
                indent = {
                    enable = true,
                    disable = function(language)
                        return language ~= 'yaml' or disable_treesitter()
                    end,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = '<bs>',
                        node_incremental = '<bs>',
                        scope_incremental = false,
                        node_decremental = '<leader><bs>',
                    },
                },
            })

            vim.keymap.set('n', '<leader>fo', function()
                if vim.wo.foldmethod == 'manual' then
                    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                    vim.wo.foldmethod = 'expr'
                else
                    vim.api.nvim_feedkeys('zE', 'n', true)
                    vim.wo.foldmethod = 'manual'
                    vim.wo.foldexpr = ''
                end
            end, {
                silent = true,
                desc = 'Toggle treesitter [f][o]lds',
            })
        end,
    },
    {
        'andymass/vim-matchup',
        event = 'LazyFile',
        config = function()
            vim.g.matchup_matchparen_offscreen = {}
            -- Fixes this https://github.com/andymass/vim-matchup/issues/328
            vim.g.matchup_matchparen_deferred = true
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        event = 'LazyFile',
        config = function()
            local ts_context = require('treesitter-context')

            ts_context.setup({
                enable = false,
                max_lines = 3,
            })

            vim.keymap.set('n', '<leader>cc', ts_context.toggle, {
                silent = true,
                noremap = true,
                desc = 'Context toggle',
            })
        end,
    },
    {
        'Wansmer/treesj',
        opts = {
            use_default_keymaps = false,
        },
        keys = {
            {
                '<leader>as',
                function()
                    require('treesj').split()
                end,
                desc = '[a]rguments [s]plit (treesj)',
            },
            {
                '<leader>aj',
                function()
                    require('treesj').join()
                end,
                desc = '[a]rguments [j]join (treesj)',
            },
        },
    },
}
