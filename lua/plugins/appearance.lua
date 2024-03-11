local common = require('common')

return {
    {
        'rebelot/kanagawa.nvim',
        config = function()
            require('kanagawa').setup({
                compile = true,
                colors = {
                    theme = { all = { diag = { error = '#C34043' } } },
                },
                overrides = function(_)
                    return {
                        ['@markup.raw'] = { link = 'Comment' },
                        ['@markup.link.label.markdown_inline'] = { link = 'WarningMsg' },
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
            hooks.register(hooks.type.SCOPE_ACTIVE, function()
                return not vim.b['too_large_for_treesitter']
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
                        'nasm',
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
        event = 'LazyFile',
        config = function()
            local function keymap_section()
                local prefix = '🌎 '

                if vim.o.iminsert > 0 and vim.b['keymap_name'] ~= nil then
                    return prefix .. vim.b['keymap_name']
                end

                return prefix .. 'en'
            end

            local lsp_server_icon = {
                lua_ls = ' ',
                ['rust-analyzer'] = ' ',
                clangd = '🐉',
                hls = ' ',
            }

            local function lsp_status_section()
                if vim.tbl_count(vim.lsp.get_clients()) == 0 then
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

                if lsp_server_icon[last_message.name] ~= nil then
                    contents = string.format('%s %s', lsp_server_icon[last_message.name], contents)
                else
                    contents = string.format('[%s] %s', last_message.name, contents)
                end

                return string.sub(contents, 1, 40)
            end

            local lualine_require = require('lualine_require')
            lualine_require.require = require

            require('lualine').setup({
                options = {
                    disabled_filetypes = {
                        statusline = { 'dashboard' },
                    },
                    section_separators = { left = '', right = '' },
                    component_separators = { left = '', right = '▕ ' },
                },
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                },
                sections = {
                    lualine_a = {},
                    lualine_c = { lsp_status_section },
                    lualine_x = {
                        { keymap_section, padding = 0 },
                        { 'filetype', padding = 0 },
                        { 'encoding', padding = 0 },
                        {
                            'fileformat',
                            padding = 0,
                            symbols = {
                                unix = 'unix',
                                dos = 'dos',
                                mac = 'mac',
                            },
                        },
                        { 'filesize', padding = 0 },
                    },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' },
                },
            })
        end,
    },
    {
        'kevinhwang91/nvim-bqf',
        event = 'QuickFixCmdPre',
        opts = {
            preview = {
                winblend = 0,
                auto_preview = false,
            },
        },
    },
    {
        'stevearc/dressing.nvim',
        lazy = true,
        opts = {
            input = {
                insert_only = false,
                start_in_insert = false,
                win_options = {
                    winblend = 0,
                    winhighlight = table.concat({
                        'Normal:Normal',
                        'FloatBorder:TelescopeBorder',
                        'FloatTitle:TelescopeTitle',
                    }, ','),
                },
                border = 'single',
            },
            select = {
                backend = { 'telescope', 'builtin' },
                builtin = {
                    win_options = {
                        winblend = 0,
                        winhighlight = 'Normal:Normal',
                    },
                    border = 'single',
                },
                telescope = {
                    theme = 'ivy',
                    sorting_strategy = 'ascending',
                    layout_strategy = 'center',
                    layout_config = {
                        height = 0.4,
                        width = 0.5,
                    },
                    border = true,
                    borderchars = {
                        prompt = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                        results = { '─', '│', '─', '│', '├', '┤', '┘', '└' },
                        preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
                    },
                },
            },
        },
        init = function()
            --- @diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require('lazy').load({ plugins = { 'dressing.nvim' } })
                return vim.ui.select(...)
            end

            --- @diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require('lazy').load({ plugins = { 'dressing.nvim' } })
                return vim.ui.input(...)
            end
        end,
    },
    {
        'nvimdev/dashboard-nvim',
        event = 'VimEnter',
        config = function()
            local headers = {
                {
                    '',
                    [[ ()()         ____ ]],
                    [[ (..)        /|o  |]],
                    [[ /\/\       /o|  o|]],
                    [[c\db/o...  /o_|_o_|]],
                    '',
                    '',
                },
                {
                    '',
                    [[  __      _]],
                    [[o'')}____//]],
                    [[ `_/      )]],
                    [[ (_(_/-(_/ ]],
                    [[           ]],
                    '',
                },
                {
                    '',
                    [[       .                 ]],
                    [[      ":"                ]],
                    [[    ___:____     |"\/"|  ]],
                    [[  ,'        `.    \  /   ]],
                    [[  |  O        \___/  |   ]],
                    [[~^~^~^~^~^~^~^~^~^~^~^~^~]],
                    [[                         ]],
                    '',
                },
                {
                    '',
                    [[   ___     ___  ]],
                    [[  (o o)   (o o) ]],
                    [[ (  V  ) (  V  )]],
                    [[/--m-m- /--m-m- ]],
                    [[                ]],
                    '',
                },
                {
                    '',
                    [[    |\__/,|   (`\ ]],
                    [[  _.|o o  |_   ) )]],
                    [[-(((---(((--------]],
                    [[                  ]],
                    '',
                },
                {
                    '',
                    [[\|/          (__)     ]],
                    [[     `\------(oo)     ]],
                    [[       ||    (__)     ]],
                    [[       ||w--||     \|/]],
                    [[   \|/                ]],
                    [[                      ]],
                    '',
                },
                {
                    '',
                    [[    .----.   @   @]],
                    [[   / .-"-.`.  \v/ ]],
                    [[   | | '\ \ \_/ ) ]],
                    [[ ,-\ `-.' /.'  /  ]],
                    [['---`----'----'   ]],
                    [[                  ]],
                    '',
                },
                {
                    '',
                    [[   ╱|、     ]],
                    [[ (˚ˎ 。7    ]],
                    [[  |、˜〵    ]],
                    [[  じしˍ,)ノ ]],
                    [[            ]],
                    '',
                },
            }

            vim.cmd.highlight({ 'link', 'DashboardHeader', 'DashboardFooter', bang = true })

            local version = vim.version()

            require('dashboard').setup({
                theme = 'doom',
                hide = {
                    winbar = false,
                    statusline = true,
                    tabline = false,
                },
                config = {
                    header = headers[math.random(1, #headers)],
                    center = {
                        {
                            icon = '  ',
                            desc = 'Open configs            ',
                            key = 'c',
                            action = function()
                                local config_dir = vim.fn.stdpath('config')
                                if type(config_dir) == 'table' then
                                    config_dir = config_dir[0]
                                end

                                vim.loop.chdir(config_dir)
                                require('oil').open(config_dir)
                            end,
                        },
                        {
                            icon = '  ',
                            desc = 'Open projects',
                            key = 'p',
                            action = function()
                                local projects_dir = '~/_/Coding/'
                                vim.loop.chdir(projects_dir)
                                require('oil').open(projects_dir)
                            end,
                        },
                        {
                            icon = '󰒲  ',
                            desc = 'Lazy',
                            key = 'l',
                            action = function()
                                require('lazy').home()
                            end,
                        },
                        {
                            icon = '󰣪  ',
                            desc = 'Mason',
                            key = 'm',
                            action = function()
                                require('mason.ui').open()
                            end,
                        },
                        {
                            icon = '󰍃  ',
                            desc = 'Quit',
                            key = 'q',
                            action = function()
                                vim.cmd.qa({ bang = true })
                            end,
                        },
                    },
                    footer = {
                        '',
                        string.format(
                            'Neovim v%s.%s.%s',
                            version.major,
                            version.minor,
                            version.patch
                        ),
                    },
                },
            })
        end,
    },
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
                -- https://github.com/neovide/neovide/issues/2291#issuecomment-1987399767
                lead_custom_section = function()
                    return { { ' ', 'WinBar' } }
                end,
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
                large_file_cutoff = common.too_many_lines,
                filetypes_denylist = { 'fugitive', 'qf' },
            })
        end,
    },
    {
        'luukvbaal/statuscol.nvim',
        branch = '0.10',
        event = 'LazyFile',
        config = function()
            local builtin = require('statuscol.builtin')

            require('statuscol').setup({
                ft_ignore = { 'oil' },
                segments = {
                    {
                        sign = {
                            namespace = { 'gitsign' },
                            maxwidth = 1,
                            colwidth = 1,
                            auto = false,
                        },
                    },
                    {
                        sign = {
                            namespace = { '/*diagnostic/signs' },
                            maxwidth = 1,
                            colwidth = 2,
                            auto = false,
                        },
                    },
                    {
                        sign = {
                            name = { 'DapBreakpoint', 'DapStopped' },
                            maxwidth = 1,
                            colwidth = 2,
                            auto = true,
                        },
                    },
                    {
                        text = { builtin.lnumfunc, ' ' },
                    },
                },
            })
        end,
    },
    {
        -- try out echasnovski/mini.hipatterns instead?
        'brenoprata10/nvim-highlight-colors',
        cond = false,
        event = 'LazyFile',
        config = true,
    },
}
