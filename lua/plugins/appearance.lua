return {
    {
        'nvim-treesitter/nvim-treesitter-context',
        event = 'LazyFile',
        opts = {
            enable = false,
        },
        keys = {
            {
                '<leader>cc',
                '<cmd>TSContextToggle<cr>',
                mode = { 'n' },
                desc = 'context toggle',
            },
        },
    },
    {
        'rebelot/kanagawa.nvim',
        config = function()
            require('kanagawa').setup({
                compile = true,
                -- https://github.com/rebelot/kanagawa.nvim/issues/197
                overrides = function(_)
                    return {
                        ['@string.regexp'] = { link = '@string.regex' },
                        ['@variable.parameter'] = { link = '@parameter' },
                        ['@exception'] = { link = '@exception' },
                        ['@string.special.symbol'] = { link = '@symbol' },
                        ['@markup.heading'] = { link = '@text.title' },
                        ['@markup.raw'] = { link = '@text.literal' },
                        ['@markup.quote'] = { link = '@text.quote' },
                        ['@markup.math'] = { link = '@text.math' },
                        ['@markup.environment'] = { link = '@text.environment' },
                        ['@markup.environment.name'] = { link = '@text.environment.name' },
                        ['@markup.link.url'] = { link = 'Special' },
                        ['@markup.link.label'] = { link = 'Identifier' },
                        ['@comment.note'] = { link = '@text.note' },
                        ['@comment.warning'] = { link = '@text.warning' },
                        ['@comment.danger'] = { link = '@text.danger' },
                        ['@diff.plus'] = { link = '@text.diff.add' },
                        ['@diff.minus'] = { link = '@text.diff.delete' },
                        ['@comment.todo'] = { link = '@text.todo' },
                    }
                end,
            })

            vim.cmd.colorscheme('kanagawa')
        end,
        priority = 1000,
        lazy = false,
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        event = 'LazyFile',
        config = function()
            local hooks = require('ibl.hooks')
            hooks.register(hooks.type.SCOPE_ACTIVE, function(buffer)
                return vim.api.nvim_buf_line_count(buffer) < require('util').large_file_lines_count
            end)

            require('ibl').setup({
                exclude = {
                    filetypes = {
                        'dashboard',
                        'lspinfo',
                        'checkhealth',
                        'help',
                        'man',
                        'fugitive',
                        '',
                    },
                },
                scope = {
                    enabled = true,
                    show_start = false,
                    show_end = false,
                    highlight = { 'Function' },
                },
                indent = {
                    tab_char = '▎',
                },
            })
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        event = 'VeryLazy',
        config = function()
            local function keymap_section()
                local prefix = '🌐 '

                if vim.o.iminsert > 0 and vim.b['keymap_name'] ~= nil then
                    return prefix .. vim.b['keymap_name']
                end

                return prefix .. 'en'
            end

            local spinner_symbols = { '◜', '◠', '◝', '◞', '◡', '◟' }
            local lsp_server_icon = {
                lua_ls = '',
                rust_analyzer = '',
                clangd = '🐉',
            }

            local function lsp_status_section()
                if vim.tbl_count(vim.lsp.get_active_clients()) == 0 then
                    return ''
                end

                local ok, lsp_status = pcall(require, 'lsp-status')
                if not ok then
                    return ''
                end

                local messages = lsp_status.messages()
                if #messages == 0 then
                    return ''
                end

                local last_message = messages[#messages]
                if not last_message.progress then
                    return ''
                end

                local contents =
                    string.format('%s %s', last_message.title, last_message.message or '')

                if last_message.spinner ~= nil then
                    local spinner_symbol =
                        spinner_symbols[(last_message.spinner % #spinner_symbols) + 1]
                    contents = string.format('%s %s', spinner_symbol, contents)
                end

                if lsp_server_icon[last_message.name] ~= nil then
                    contents = string.format('%s %s', lsp_server_icon[last_message.name], contents)
                else
                    contents = string.format('[%s] %s', last_message.name, contents)
                end

                return string.sub(contents, 1, 40)
            end

            require('lualine').setup({
                options = {
                    disabled_filetypes = {
                        statusline = {
                            'alpha',
                        },
                    },
                },
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                },
                sections = {
                    lualine_a = {},
                    lualine_c = { lsp_status_section },
                    lualine_x = { keymap_section, 'encoding', 'fileformat', 'filetype', 'filesize' },
                },
            })
        end,
    },
    {
        'kevinhwang91/nvim-bqf',
        event = { 'QuickFixCmdPre' },
        opts = {
            preview = {
                winblend = 0,
                auto_preview = false,
            },
        },
    },
    {
        'stevearc/dressing.nvim',
        opts = {
            input = {
                win_options = {
                    winblend = 0,
                },
            },
            select = {
                nui = {
                    win_options = {
                        winblend = 0,
                    },
                },
            },
        },
        event = 'VeryLazy',
    },
    {
        'goolord/alpha-nvim',
        event = 'VimEnter',
        config = function()
            local dashboard = require('alpha.themes.dashboard')

            -- https://www.asciiart.eu
            local headers = {
                {
                    [[ ()()         ____ ]],
                    [[ (..)        /|o  |]],
                    [[ /\/\       /o|  o|]],
                    [[c\db/o...  /o_|_o_|]],
                },
                {
                    [[  __      _]],
                    [[o'')}____//]],
                    [[ `_/      )]],
                    [[ (_(_/-(_/ ]],
                },
                {
                    [[       .                 ]],
                    [[      ":"                ]],
                    [[    ___:____     |"\/"|  ]],
                    [[  ,'        `.    \  /   ]],
                    [[  |  O        \___/  |   ]],
                    [[~^~^~^~^~^~^~^~^~^~^~^~^~]],
                },
                {
                    [[   ___     ___  ]],
                    [[  (o o)   (o o) ]],
                    [[ (  V  ) (  V  )]],
                    [[/--m-m- /--m-m- ]],
                },
                {
                    [[    |\__/,|   (`\ ]],
                    [[  _.|o o  |_   ) )]],
                    [[-(((---(((--------]],
                },
                {
                    [[\|/          (__)     ]],
                    [[     `\------(oo)     ]],
                    [[       ||    (__)     ]],
                    [[       ||w--||     \|/]],
                    [[   \|/                ]],
                },
                {
                    [[    .----.   @   @]],
                    [[   / .-"-.`.  \v/ ]],
                    [[   | | '\ \ \_/ ) ]],
                    [[ ,-\ `-.' /.'  /  ]],
                    [['---`----'----'   ]],
                },
            }

            dashboard.section.header.val = headers[math.random(1, #headers)]

            local version = vim.version()
            dashboard.section.footer.val = {
                '',
                string.format('Neovim v%s.%s.%s', version.major, version.minor, version.patch),
            }
            dashboard.section.footer.opts.position = 'center'

            dashboard.section.buttons.opts.spacing = 0
            dashboard.section.buttons.val = {
                dashboard.button(
                    'c',
                    '　Open configs',
                    [[<cmd>lua vim.cmd.e(vim.fn.stdpath('config')); vim.cmd.norm('`')<cr>]]
                ),
                dashboard.button('p', '　Open projects', [[<cmd>e ~/_/Coding<cr>]]),
                dashboard.button('l', '󰒲　Lazy', [[<cmd>Lazy<cr>]]),
                dashboard.button('m', '󰣪　Mason', [[<cmd>Mason<cr>]]),
                dashboard.button('q', '󰍃　Quit', [[<cmd>qa!<cr>]]),
            }

            require('alpha').setup(dashboard.opts)
        end,
    },
    -- NOTE: Maybe switch to this https://github.com/Bekaboo/dropbar.nvim once Neovim 0.10 gets
    -- released?
    {
        'utilyre/barbecue.nvim',
        version = '*',
        dependencies = {
            'SmiteshP/nvim-navic',
            'nvim-tree/nvim-web-devicons',
        },
        event = { 'LazyFile', 'LspAttach' },
        config = function()
            require('barbecue').setup({
                create_autocmd = false,
                exclude_filetypes = { 'oil' },
            })

            vim.api.nvim_create_autocmd({
                'WinResized',
                'BufWinEnter',
                'CursorHold',
                'InsertLeave',
            }, {
                group = vim.api.nvim_create_augroup('barbecue.updater', {}),
                callback = function()
                    require('barbecue.ui').update()
                end,
            })
        end,
    },
    {
        'RRethy/vim-illuminate',
        event = 'LazyFile',
        config = function()
            vim.api.nvim_set_hl(0, 'IlluminatedWordText', { link = 'Search' })
            vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { link = 'Search' })
            vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { link = 'Search' })

            require('illuminate').configure({
                delay = 750,
                large_file_cutoff = require('util').large_file_lines_count,
            })
        end,
    },
}
