local util = require('util')

local function disable(_, buffer)
    return vim.api.nvim_buf_line_count(buffer) > util.large_file_lines_count
end

local function disable_indent(language, buffer)
    return disable(language, buffer) or util.contains(language, { 'rust', 'c' })
end

return {
    {
        'nvim-treesitter/nvim-treesitter',
        event = { 'LazyFile', 'VeryLazy' },
        -- https://github.com/LazyVim/LazyVim/blob/78e6405f90eeb76fdf8f1a51f9b8a81d2647a698/lua/lazyvim/plugins/treesitter.lua#L11
        init = function(plugin)
            require('lazy.core.loader').add_to_rtp(plugin)
            require('nvim-treesitter.query_predicates')
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        config = function()
            --- @diagnostic disable-next-line: missing-fields
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    'lua',
                    'vimdoc',
                },
                auto_install = false,
                highlight = {
                    enable = true,
                    disable = disable,
                },
                matchup = {
                    enable = true,
                    enable_quotes = true,
                    disable = disable,
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
                            ['ab'] = '@block.outer',
                            ['ib'] = '@block.inner',
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
                    disable = disable_indent,
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
        end,
    },
    {
        'andymass/vim-matchup',
        event = 'LazyFile',
        config = function()
            vim.g.matchup_matchparen_offscreen['method'] = 'status_manual'
        end,
    },
}
