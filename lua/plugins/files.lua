return {
    {
        'stevearc/oil.nvim',
        event = 'VeryLazy',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local oil = require('oil')

            oil.setup({
                view_options = {
                    show_hidden = true,
                    natural_order = false,
                },
                win_options = {
                    concealcursor = 'nicv',
                },
                skip_confirm_for_simple_edits = true,
            })

            vim.keymap.set('n', '<leader>e', oil.open, {
                desc = 'File [e]xplorer (oil.nvim)',
            })
        end,
    },
    {
        'echasnovski/mini.files',
        config = function()
            require('mini.files').setup()
        end,
        keys = {
            {
                '<leader>o',
                function()
                    require('mini.files').open()
                end,
                mode = 'n',
            },
        },
    },
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'debugloop/telescope-undo.nvim',
            'nvim-telescope/telescope-live-grep-args.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = table.concat({
                    'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release',
                    'cmake --build build --config Release',
                    'cmake --install build --prefix build',
                }, '&&'),
                cond = function()
                    return vim.fn.executable('cmake') == 1
                end,
            },
            'nvim-telescope/telescope-symbols.nvim',
        },
        config = function()
            local telescope = require('telescope')
            local lga_actions = require('telescope-live-grep-args.actions')

            telescope.setup({
                extensions = {
                    undo = {},
                    live_grep_args = {
                        auto_quoting = true,
                        mappings = {
                            i = {
                                ['<C-i>'] = lga_actions.quote_prompt({
                                    postfix = ' --hidden --iglob ',
                                }),
                                ['<C-h>'] = lga_actions.quote_prompt({
                                    postfix = ' --hidden --iglob !.git',
                                }),
                            },
                        },
                    },
                },
                pickers = {
                    find_files = {
                        find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' },
                    },
                    live_grep = {
                        additional_args = { '--hidden', '--iglob', '!.git' },
                    },
                },
                defaults = {
                    borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                    mappings = {
                        i = {
                            ['<C-l>'] = { '<C-^>', type = 'command' },
                        },
                    },
                    preview = {
                        treesitter = false,
                    },
                },
            })

            pcall(telescope.load_extension, 'undo')
            pcall(telescope.load_extension, 'live_grep_args')
            pcall(telescope.load_extension, 'fzf')
        end,
        keys = {
            {
                '<leader>sf',
                function()
                    require('telescope.builtin').find_files()
                end,
                desc = '[s]earch [f]iles',
            },
            {
                '<leader>sb',
                function()
                    require('telescope.builtin').buffers()
                end,
                desc = '[s]earch [b]uffers',
            },
            {
                '<leader>sc',
                function()
                    require('telescope.builtin').command_history()
                end,
                desc = '[s]earch [c]ommand history',
            },
            {
                '<leader>sg',
                function()
                    require('telescope.builtin').live_grep()
                end,
                desc = '[s]earch [g]rep',
            },
            {
                '<leader>sm',
                function()
                    require('telescope.builtin').marks()
                end,
                desc = '[s]earch [m]arks',
            },
            {
                '<leader>sj',
                function()
                    require('telescope.builtin').jumplist()
                end,
                desc = '[s]earch [j]umplist',
            },
            {
                '<leader>sh',
                function()
                    require('telescope.builtin').help_tags()
                end,
                desc = '[s]earch [h]elp',
            },
            {
                '<leader>/',
                function()
                    require('telescope.builtin').current_buffer_fuzzy_find()
                end,
                desc = 'Fuzzy find on the current buffer',
            },
            {
                '<leader>lga',
                function()
                    require('telescope').extensions.live_grep_args.live_grep_args()
                end,
                desc = '[l]ive [g]rep [a]rgs',
            },
            {
                '<leader>su',
                function()
                    require('telescope').extensions.undo.undo()
                end,
                desc = '[s]earch [u]ndo',
            },
            {
                '<leader>st',
                function()
                    require('telescope.builtin').treesitter()
                end,
                desc = '[s]earch [t]reesitter',
            },
            {
                '<leader>ds',
                function()
                    require('telescope.builtin').lsp_document_symbols()
                end,
                desc = '[d]ocument [s]ymbols',
            },
            {
                '<leader>ws',
                function()
                    require('telescope.builtin').lsp_dynamic_workspace_symbols()
                end,
                desc = '[w]orkspace [s]ymbols',
            },
            {
                'gr',
                function()
                    require('telescope.builtin').lsp_references()
                end,
                desc = 'Show references (LSP)',
            },
            {
                'gI',
                function()
                    require('telescope.builtin').lsp_implementations()
                end,
                desc = 'Show implementations (LSP)',
            },
        },
        cmd = { 'Telescope' },
    },
    {
        'romgrk/barbar.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        init = function()
            vim.g.barbar_auto_setup = false
        end,
        event = 'LazyFile',
        config = function()
            require('barbar').setup({
                animation = false,
                exclude_ft = { 'oil', 'qf', 'fugitive' },
                exclude_name = { 'UnicodeTable.txt' },
                icons = {
                    button = false,
                    separator_at_end = false,
                },
                highlight_alternate = true,
            })

            local barbar = require('barbar.api')

            vim.keymap.set('n', '<leader>bp', barbar.pick_buffer, { desc = '[b]uffer [p]ick' })

            vim.keymap.set('n', '[b', function()
                barbar.goto_buffer_relative(-1)
            end, { desc = 'Go to previous buffer' })

            vim.keymap.set('n', ']b', function()
                barbar.goto_buffer_relative(1)
            end, { desc = 'Go to next buffer' })

            vim.keymap.set(
                'n',
                '<leader>X',
                barbar.close_all_but_current,
                { desc = 'Close all buffers but current' }
            )

            vim.keymap.set('n', '<leader>x', function()
                vim.cmd({ cmd = 'BufferClose', bang = true })
            end, { desc = 'Close current buffer' })

            vim.keymap.set(
                'n',
                '<leader>bch',
                barbar.close_buffers_left,
                { desc = 'Close all buffers to the left' }
            )

            vim.keymap.set(
                'n',
                '<leader>bcl',
                barbar.close_buffers_right,
                { desc = 'Close all buffers to the right' }
            )
        end,
    },
}
