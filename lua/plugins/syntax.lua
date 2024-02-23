local function disable(language, buffer)
    return vim.api.nvim_buf_line_count(buffer) > require('util').large_file_lines_count
end

return {
    {
        'nvim-treesitter/nvim-treesitter',
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    'cpp',
                    'rust',
                    'json',
                    'xml',
                    'lua',
                    'yaml',
                    'toml',
                    'glsl',
                    'cmake',
                    'c',
                },
                highlight = {
                    enable = true,
                    disable = disable,
                },
                matchup = {
                    enable = true,
                    enable_quotes = true,
                    disable = disable,
                },
            })
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        },
        event = 'VeryLazy',
        config = function()
            require('nvim-treesitter.configs').setup({
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
                    disable = disable,
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
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        },
        event = { 'BufReadPost', 'BufNewFile' },
        config = function()
            vim.g.matchup_matchparen_offscreen['method'] = 'status_manual'
        end,
    },
    {
        'rust-lang/rust.vim',
        ft = { 'rust' },
    },
}
