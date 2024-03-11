local common = require('common')

local function on_attach(client, buffer)
    require('lsp-status').on_attach(client)

    if client.name == 'rust-analyzer' then
        vim.keymap.set('n', '<leader>rr', function()
            vim.cmd.RustLsp('run')
        end, {
            desc = '[r]ust [r]un',
            buffer = buffer,
        })

        vim.keymap.set('n', '<leader>ru', function()
            vim.cmd.RustLsp('runnables')
        end, {
            desc = '[r]ust r[u]unnables',
            buffer = buffer,
        })

        vim.keymap.set('n', '<leader>rd', function()
            vim.cmd.RustLsp('debug')
        end, {
            desc = '[r]ust [d]ebug',
            buffer = buffer,
        })

        vim.keymap.set('n', '<leader>ha', function()
            vim.cmd.RustLsp({ 'hover', 'actions' })
        end, {
            desc = '[h]over [a]ctions',
            buffer = buffer,
        })
    end

    if
        client.supports_method(vim.lsp.protocol.Methods.textDocument_documentSymbol)
        or client.server_capabilities.documentSymbolProvider
    then
        require('nvim-navic').attach(client, buffer)
    end

    if
        client.supports_method(vim.lsp.protocol.Methods.textDocument_rename)
        or client.server_capabilities.renameProvider
    then
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {
            desc = '[r]e[n]ame',
            buffer = buffer,
        })
    end

    if
        client.supports_method(vim.lsp.protocol.Methods.textDocument_codeAction)
        or client.server_capabilities.codeActionProvider
    then
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {
            desc = '[c]ode [a]ction',
            buffer = buffer,
        })
    end

    if
        client.supports_method(vim.lsp.protocol.Methods.textDocument_definition)
        or client.server_capabilities.definitionProvider
    then
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {
            desc = '[g]o to [d]efinition',
            buffer = buffer,
        })
    end

    if
        client.supports_method(vim.lsp.protocol.Methods.textDocument_declaration)
        or client.server_capabilities.declarationProvider
    then
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {
            desc = '[g]o to [D]eclaration',
            buffer = buffer,
        })
    end

    if
        client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint)
        or client.server_capabilities.inlayHintProvider
    then
        vim.keymap.set('n', '<leader>i', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
        end, {
            desc = '[i]nlay hints toggle',
            buffer = buffer,
        })
    end

    local lsp_ui = require('lsp_ui')

    if
        client.supports_method(vim.lsp.protocol.Methods.textDocument_hover)
        or client.server_capabilities.hoverProvider
    then
        vim.keymap.set('n', 'K', function()
            local params = vim.lsp.util.make_position_params()
            vim.lsp.buf_request(
                0,
                vim.lsp.protocol.Methods.textDocument_hover,
                params,
                lsp_ui.hover
            )
        end, {
            buffer = buffer,
        })
    end

    if
        client.supports_method(vim.lsp.protocol.Methods.textDocument_signatureHelp)
        or client.server_capabilities.signatureHelpProvider
    then
        vim.keymap.set({ 'i', 'n' }, '<c-j>', function()
            local params = vim.lsp.util.make_position_params()
            vim.lsp.buf_request(
                0,
                vim.lsp.protocol.Methods.textDocument_signatureHelp,
                params,
                lsp_ui.signature_help
            )
        end, {
            buffer = buffer,
        })
    end
end

local lsp_kind_map = {
    Text = '󰉿 ',
    Method = '󰊕 ',
    Function = '󰊕 ',
    Constructor = '󰊕 ',
    Field = '󰜢 ',
    Variable = '󰀫 ',
    Class = '󰠱 ',
    Interface = ' ',
    Module = ' ',
    Property = '󰜢 ',
    Unit = '󰑭 ',
    Value = '󰎠 ',
    Enum = ' ',
    Keyword = '󰌋 ',
    Snippet = ' ',
    Color = '󰏘 ',
    File = '󰈙 ',
    Reference = '󰈇 ',
    Folder = '󰉋 ',
    EnumMember = ' ',
    Constant = '󰏿 ',
    Struct = '󰙅 ',
    Event = ' ',
    Operator = '󰆕 ',
    TypeParameter = '',
}

return {
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',

            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'rafamadriz/friendly-snippets',

            {
                'windwp/nvim-autopairs',
                event = 'InsertEnter',
                config = function()
                    require('nvim-autopairs').setup()

                    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
                    local cmp = require('cmp')
                    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
                end,
            },
        },
        event = 'InsertEnter',
        config = function()
            local cmp = require('cmp')

            local luasnip = require('luasnip')
            local luasnip_types = require('luasnip.util.types')
            luasnip.setup({
                region_check_events = { 'InsertEnter', 'CursorMoved', 'CursorHold' },
                delete_check_events = { 'TextChanged', 'InsertLeave' },
                ext_opts = {
                    [luasnip_types.choiceNode] = {
                        active = {
                            virt_text = { { '󰧞' } },
                        },
                    },
                    [luasnip_types.insertNode] = {
                        active = {
                            virt_text = { { '󰧞' } },
                        },
                    },
                },
            })
            vim.keymap.set('n', '<leader>sa', function()
                luasnip.unlink_current()
            end, {
                desc = '[s]nippet [a]bort',
                silent = true,
            })
            require('luasnip.loaders.from_vscode').lazy_load()

            cmp.setup({
                preselect = 'None',
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<c-n>'] = cmp.mapping.select_next_item({
                        behavior = cmp.SelectBehavior.Insert,
                    }),
                    ['<c-p>'] = cmp.mapping.select_prev_item({
                        behavior = cmp.SelectBehavior.Insert,
                    }),
                    ['<c-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<c-d>'] = cmp.mapping.scroll_docs(4),
                    ['<tab>'] = cmp.mapping(function(fallback)
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<s-tab>'] = cmp.mapping(function(fallback)
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<c-s>'] = cmp.mapping.complete({}),
                    ['<cr>'] = cmp.mapping.confirm({
                        select = true,
                        behavior = cmp.ConfirmBehavior.Replace,
                    }),
                }),
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    {
                        name = 'buffer',
                        option = {
                            indexing_interval = 1000,
                            get_bufnrs = function()
                                local buffers = vim.api.nvim_list_bufs()

                                local large_buffer_found = false
                                for _, buffer in ipairs(buffers) do
                                    local buffer_size = vim.api.nvim_buf_get_offset(
                                        buffer,
                                        vim.api.nvim_buf_line_count(buffer)
                                    )

                                    if buffer_size > common.way_too_large then
                                        large_buffer_found = true
                                        break
                                    end
                                end

                                if large_buffer_found then
                                    return {}
                                else
                                    return buffers
                                end
                            end,
                        },
                    },
                    { name = 'path' },
                },
                --- @diagnostic disable-next-line: missing-fields
                formatting = {
                    format = function(_, vim_item)
                        vim_item.abbr = string.sub(vim_item.abbr, 1, 20)
                        vim_item.menu = ''
                        vim_item.kind = lsp_kind_map[vim_item.kind]
                        return vim_item
                    end,
                    fields = { 'kind', 'abbr' },
                },
                window = {
                    documentation = {
                        max_width = 60,
                    },
                },
                completion = {
                    completeopt = 'menu,menuone,noselect,noinsert',
                },
            })
        end,
    },
    {
        'williamboman/mason.nvim',
        config = true,
        cmd = { 'Mason', 'MasonInstall' },
    },
    {
        'stevearc/conform.nvim',
        event = 'LazyFile',
        cmd = { 'ConformInfo' },
        dependencies = { 'williamboman/mason.nvim' },
        keys = {
            {
                '<leader>ff',
                function()
                    require('conform').format({ async = true, lsp_fallback = true })
                end,
                mode = { 'n', 'v' },
                desc = 'Format buffer',
            },
        },
        opts = {
            formatters_by_ft = {
                lua = { 'stylua' },
                c = { 'clang_format' },
                rust = { 'rustfmt' },
                cmake = { 'cmake_format' },
                json = { 'jq' },
                typescript = { 'prettierd' },
                html = { 'prettierd' },
                javascript = { 'prettierd' },
            },
            formatters = {
                jq = {
                    prepend_args = { '--indent', 4, '--monochrome-output' },
                },
            },
        },
    },
    {
        'nvim-lua/lsp-status.nvim',
        event = 'LspAttach',
        config = function()
            local lsp_status = require('lsp-status')
            lsp_status.config({
                current_function = false,
                show_filename = false,
                diagnostics = false,
            })
            lsp_status.register_progress()
        end,
    },
    {
        'SmiteshP/nvim-navic',
        event = { 'LazyFile', 'LspAttach' },
    },
    {
        'neovim/nvim-lspconfig',
        event = 'LazyFile',
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
            'williamboman/mason.nvim',
            'folke/neodev.nvim',
            'nvim-lua/lsp-status.nvim',
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function()
            vim.lsp.set_log_level('OFF')

            local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview

            --- @diagnostic disable-next-line: duplicate-set-field
            vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
                opts = opts or {}
                opts.max_width = 60
                return orig_util_open_floating_preview(contents, syntax, opts, ...)
            end

            vim.diagnostic.config({
                virtual_text = false,
                underline = true,
                severity_sort = true,
                signs = common.diagnostic_signs,
            })

            require('neodev').setup()

            local servers = {
                lua_ls = {
                    Lua = {
                        hint = { enable = true },
                        workspace = { checkThirdParty = false },
                        codeLens = { enable = false },
                        completion = { callSnippet = 'Replace' },
                    },
                },
                clangd = {
                    cmd = {
                        'clangd',
                        '--background-index',
                        '--clang-tidy',
                        '--header-insertion=never',
                        '--completion-style=detailed',
                        '--function-arg-placeholders=true',
                        '--fallback-style=llvm',
                    },
                },
            }

            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            capabilities =
                vim.tbl_deep_extend('keep', capabilities, require('lsp-status').capabilities)

            local mason_lspconfig = require('mason-lspconfig')
            mason_lspconfig.setup({
                ensure_installed = {},
            })
            mason_lspconfig.setup_handlers({
                function(server_name)
                    require('lspconfig')[server_name].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = servers[server_name],
                        filetypes = (servers[server_name] or {}).filetypes,
                        cmd = (servers[server_name] or {}).cmd,
                    })
                end,
                rust_analyzer = function() end,
            })
        end,
    },
    -- This plugin requires rust-analyzer to be added like this: `rustup component add
    -- rust-analyzer`. It does not use the rust-analyzer installed by Mason.
    {
        'mrcjkb/rustaceanvim',
        event = 'LazyFile',
        init = function()
            vim.g.rustaceanvim = function()
                -- https://github.com/mrcjkb/rustaceanvim?tab=readme-ov-file#using-codelldb-for-debugging
                local extension_path = vim.env.HOME
                    .. '/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/'
                local codelldb_path = extension_path .. 'adapter/codelldb'
                local liblldb_path = extension_path .. 'lldb/lib/liblldb'
                local this_os = vim.uv.os_uname().sysname

                if this_os:find('Windows') then
                    codelldb_path = extension_path .. 'adapter\\codelldb.exe'
                    liblldb_path = extension_path .. 'lldb\\bin\\liblldb.dll'
                else
                    liblldb_path = liblldb_path .. (this_os == 'Linux' and '.so' or '.dylib')
                end

                local capabilities = require('cmp_nvim_lsp').default_capabilities()
                capabilities =
                    vim.tbl_deep_extend('keep', capabilities, require('lsp-status').capabilities)

                return {
                    dap = {
                        adapter = require('rustaceanvim.config').get_codelldb_adapter(
                            codelldb_path,
                            liblldb_path
                        ),
                    },
                    tools = {
                        hover_actions = {
                            auto_focus = false,
                        },
                        crate_graph = {
                            backend = nil,
                            full = false,
                            output = nil,
                            enabled_graphviz_backends = {},
                        },
                        float_win_config = {
                            border = 'none',
                        },
                    },
                    server = {
                        capabilities = capabilities,
                        on_attach = on_attach,
                        standalone = false,
                        settings = {
                            ['rust-analyzer'] = {
                                checkOnSave = {
                                    command = 'clippy',
                                    extraArgs = { '--no-deps' },
                                },
                                diagnostics = {
                                    experimental = { enable = true },
                                    disabled = { 'inactive-code' },
                                },
                            },
                        },
                        -- https://github.com/neovim/nvim-lspconfig/issues/2518#issuecomment-1564343067
                        root_dir = function()
                            return vim.loop.cwd()
                        end,
                    },
                }
            end
        end,
    },
    {
        'nvim-neotest/neotest',
        cond = false,
        event = 'LazyFile',
        dependencies = {
            'nvim-neotest/nvim-nio',
            'nvim-lua/plenary.nvim',
            'antoinemadec/FixCursorHold.nvim',
        },
        config = function()
            --- @diagnostic disable-next-line: missing-fields
            require('neotest').setup({
                adapters = {
                    require('rustaceanvim.neotest'),
                },
            })
        end,
    },
    {
        'folke/trouble.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            auto_preview = false,
        },
        keys = {
            {
                '<leader>tt',
                function()
                    require('trouble').open('workspace_diagnostics')
                end,
                mode = 'n',
                desc = '[t]oggle [t]rouble',
            },
            {
                '<leader>tx',
                function()
                    require('trouble').close()
                end,
                mode = 'n',
                desc = 'Close the trouble window',
            },
        },
        cmd = { 'Trouble', 'TroubleClose' },
    },
}
