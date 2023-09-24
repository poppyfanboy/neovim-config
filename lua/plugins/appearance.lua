return {
    {
        'rebelot/kanagawa.nvim',
        config = function()
            require('kanagawa').setup({
                compile = true,
            })

            vim.cmd.colorscheme('kanagawa')
        end,
        priority = 1000,
        lazy = false,
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        event = 'VeryLazy',
        config = function()
            local config = {
                filetype_exclude = {
                    'dashboard',
                    'lspinfo',
                    'checkhealth',
                    'help',
                    'man',
                    '',
                },
                show_current_context = true,
                show_end_of_line = true,
                context_char = '┃',
            }

            if vim.g.neovide then
                config.char = '▏'
                config.context_char = '▏'
                config.show_current_context_start = true
            end

            require('indent_blankline').setup(config)
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        event = 'VeryLazy',
        config = function()
            local function keymap()
                local prefix = '🌐 '

                if vim.o.iminsert > 0 and vim.b.keymap_name ~= nil then
                    return prefix .. vim.b.keymap_name
                end

                return prefix .. 'en'
            end

            local spinner_symbols = { '◜', '◠', '◝', '◞', '◡', '◟' }
            local lsp_server_icon = {
                lua_ls = '',
                rust_analyzer = ''
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

                local contents = string.format('%s %s', last_message.title, last_message.message or '')

                if last_message.spinner ~= nil then
                    local spinner_symbol = spinner_symbols[(last_message.spinner % #spinner_symbols) + 1]
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
                            'oil',
                            'fugitive',
                            'dapui_scopes',
                            'dapui_breakpoints',
                            'dapui_stacks',
                            'dapui_watches',
                            'dap-repl',
                            'dapui_console',
                        },
                    },
                },
                refresh = {
                    statusline = 200,
                    tabline = 500,
                    winbar = 300,
                },
                sections = {
                    lualine_a = {},
                    lualine_c = {
                        'filename',
                        lsp_status_section,
                    },
                    lualine_x = { keymap, 'encoding', 'fileformat', 'filetype' },
                },
            })
        end,
    },
    {
        'kevinhwang91/nvim-bqf',
        config = function()
            require('bqf').setup({
                preview = {
                    winblend = 0,
                    auto_preview = false,
                },
            })
        end,
        event = { 'QuickFixCmdPre' },
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

            local datetime = os.date('%d-%m-%Y %H:%M')
            local version = vim.version()
            dashboard.section.footer.val = {
                '',
                datetime,
            }
            dashboard.section.footer.opts.position = 'center'

            dashboard.section.buttons.opts.spacing = 0
            dashboard.section.buttons.val = {
                dashboard.button('e', '　New file', [[<cmd>enew<cr>]]),
                dashboard.button('f', '　Browse files', [[<cmd>Oil<cr>]]),
                dashboard.button('t', '　Terminal', [[<cmd>ter<cr>]]),
                dashboard.button('g', '　Git', [[<cmd>Git<cr>]]),
                dashboard.button(
                    'c',
                    '　Open configs',
                    [[<cmd>lua vim.cmd.e(vim.fn.stdpath('config')); vim.cmd.norm('`')<cr>]]
                ),
                dashboard.button(
                    'p',
                    '　Open projects',
                    [[<cmd>e ~/Documents/projects<cr>]]
                ),
                dashboard.button('l', '󰒲　Lazy', [[<cmd>Lazy<cr>]]),
                dashboard.button('m', '󰣪　Mason', [[<cmd>Mason<cr>]]),
                dashboard.button('q', '󰍃　Quit', [[<cmd>qa!<cr>]]),
            }

            require('alpha').setup(dashboard.opts)
        end,
    },
    {
        'utilyre/barbecue.nvim',
        version = '*',
        dependencies = {
            'SmiteshP/nvim-navic',
            'nvim-tree/nvim-web-devicons',
        },
        event = { 'LspAttach' },
        config = function()
            require('barbecue').setup({
                create_autocmd = false,
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
}
