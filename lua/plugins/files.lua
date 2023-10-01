return {
    {
        'stevearc/oil.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('oil').setup({
                view_options = {
                    show_hidden = true,
                },
                win_options = {
                    concealcursor = 'nicv',
                },
            })

            vim.keymap.set({ 'n' }, '<leader>e', '<cmd>Oil<cr>', {
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
            { '<leader>o', '<cmd>lua MiniFiles.open()<cr>', mode = { 'n' } },
        },
    },
    {
        't9md/vim-choosewin',
        init = function()
            vim.g.choosewin_blink_on_land = false
        end,
        keys = {
            { '<leader>ss', '<cmd>ChooseWin<cr>', mode = { 'n' }, desc = { '[s]elect [s]plit' } },
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
            },
            'nvim-telescope/telescope-symbols.nvim',
        },
        config = function()
            local telescope = require('telescope')
            local lga_actions = require('telescope-live-grep-args.actions')
            local telescope_builtin = require('telescope.builtin')

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
                    mappings = {
                        i = {
                            ['<c-l>'] = { '<c-^>', type = 'command' },
                        },
                    },
                }
            })

            telescope.load_extension('undo')
            telescope.load_extension('live_grep_args')
            telescope.load_extension('fzf')
        end,
        keys = {
            { '<leader>sf',  '<cmd>Telescope find_files<cr>',            desc = '[s]earch [f]iles' },
            { '<leader>sb',  '<cmd>Telescope buffers<cr>',               desc = '[s]earch [b]uffers' },
            { '<leader>sc',  '<cmd>Telescope command_history<cr>',       desc = '[s]earch [c]ommand history' },
            { '<leader>sg',  '<cmd>Telescope live_grep<cr>',             desc = '[s]earch [g]rep' },
            { '<leader>sm',  '<cmd>Telescope marks<cr>',                 desc = '[s]earch [m]arks' },
            { '<leader>sj',  '<cmd>Telescope jumplist<cr>',              desc = '[s]earch [j]umplist' },
            { '<leader>sh',  '<cmd>Telescope help_tags<cr>',             desc = '[s]earch [g]help' },
            { '<leader>lga', '<cmd>Telescope live_grep_args<cr>',        desc = '[l]ive [g]rep [a]rgs' },
            { '<leader>su',  '<cmd>Telescope undo<cr>',                  desc = '[s]earch [u]ndo' },
            { '<leader>ds',  '<cmd>Telescope lsp_document_symbols<cr>',  desc = '[d]ocument [s]ymbols' },
            { '<leader>ws',  '<cmd>Telescope lsp_workspace_symbols<cr>', desc = '[w]orkspace [s]ymbols' },
            { 'gr',          '<cmd>Telescope lsp_references<cr>',        desc = 'Show references (LSP)' },
            { 'gI',          '<cmd>Telescope lsp_implementations<cr>',   desc = 'Show implementations (LSP)' },
        },
    },
    {
        'romgrk/barbar.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        init = function()
            vim.g.barbar_auto_setup = false
        end,
        event = 'VeryLazy',
        config = function()
            require('barbar').setup({
                animation = false,
                exclude_ft = { 'oil' },
                icons = {
                    button = false,
                },
            })

            vim.keymap.set({ 'n' }, '<leader>bp', '<cmd>BufferPick<cr>', {
                desc = '[b]uffer [p]ick',
            })
            vim.keymap.set({ 'n' }, '[b', '<cmd>BufferPrevious<cr>', {
                desc = 'Go to previous buffer',
            })
            vim.keymap.set({ 'n' }, ']b', '<cmd>BufferNext<cr>', {
                desc = 'Go to next buffer',
            })

            vim.keymap.set({ 'n' }, '<leader>bcc', '<cmd>BufferClose<cr>', {
                desc = '[b]uffer [c]lose',
            })
            vim.keymap.set({ 'n' }, '<leader>bca', '<cmd>BufferCloseAllButCurrent<cr>', {
                desc = '[b]uffer [c]lose [a]ll',
            })

            vim.keymap.set({ 'n' }, '<leader>bdd', '<cmd>BufferClose!<cr>', {
                desc = '[b]uffer [d]elete',
            })
        end,
    },
    {
        'dyng/ctrlsf.vim',
        init = function()
            vim.g.ctrlsf_populate_qflist = true
        end,
        cmd = { 'CtrlSF' },
    },
}
