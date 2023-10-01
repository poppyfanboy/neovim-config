local function on_attach(client, buffer)
    require('lsp-status').on_attach(client)
    require('nvim-navic').attach(client, buffer)
    require('lsp_signature').on_attach({
        hint_prefix = '',
        doc_lines = 0,
        toggle_key = '<c-j>',
        toggle_key_flip_floatwin_setting = true,
    }, buffer)

    if client.name == 'rust_analyzer' then
        vim.keymap.set(
            { 'n' },
            '<leader>ha',
            require('rust-tools').hover_actions.hover_actions,
            {
                desc = '[h]over [a]ctions',
                buffer = buffer,
            }
        )
    end

    vim.keymap.set({ 'n' }, '<leader>rn', vim.lsp.buf.rename, {
        desc = '[r]e[n]ame',
        buffer = buffer,
    })
    vim.keymap.set({ 'n' }, '<leader>ca', vim.lsp.buf.code_action, {
        desc = '[c]ode [a]ction',
        buffer = buffer,
    })
    vim.keymap.set({ 'n' }, 'gd', vim.lsp.buf.definition, {
        desc = '[g]o to [d]efinition',
        buffer = buffer,
    })
    vim.keymap.set({ 'n' }, 'gD', vim.lsp.buf.declaration, {
        desc = '[g]o to [D]eclaration',
        buffer = buffer,
    })
    vim.keymap.set({ 'n' }, 'K', vim.lsp.buf.hover, {
        buffer = buffer,
    })
    vim.keymap.set({ 'n' }, '<c-k>', vim.lsp.buf.signature_help, {
        buffer = buffer,
    })
    vim.keymap.set({ 'i' }, '<m-k>', vim.lsp.buf.signature_help, {
        buffer = buffer,
    })

    vim.api.nvim_buf_create_user_command(buffer, 'Format', function(_)
        vim.lsp.buf.format()
    end, {
        desc = 'Format current buffer with LSP',
    })
    vim.keymap.set({ 'n' }, '<leader>ff', [[<cmd>Format<cr>]], {
        desc = '[f]ile [f]ormat',
        buffer = buffer,
    })
end

return {
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'rafamadriz/friendly-snippets',
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
                }
            })
            vim.keymap.set({ 'n' }, '<leader>sa', function() luasnip.unlink_current() end, {
                desc = '[s]nippet [a]bort',
                silent = true,
            })
            require('luasnip.loaders.from_vscode').lazy_load()

            cmp.setup({
                preselect = 'none',
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<c-n>'] = cmp.mapping.select_next_item(),
                    ['<c-p>'] = cmp.mapping.select_prev_item(),
                    ['<c-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<c-d>'] = cmp.mapping.scroll_docs(4),
                    ['<tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<s-tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<c-s>'] = cmp.mapping.complete({}),
                    ['<cr>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                },
                formatting = {
                    format = function(entry, vim_item)
                        vim_item.abbr = string.sub(vim_item.abbr, 1, 20)
                        return vim_item
                    end,
                },
                window = {
                    documentation = {
                        max_width = 60,
                    },
                },
            })
        end,
    },
    {
        'williamboman/mason.nvim',
        config = true,
        cmd = { 'Mason' },
    },
    {
        'jay-babu/mason-null-ls.nvim',
        ft = { 'lua', 'rust' },
        dependencies = {
            'williamboman/mason.nvim',
            'nvim-lua/plenary.nvim',
            'jose-elias-alvarez/null-ls.nvim',
        },
        opts = {
            ensure_installed = { 'stylua' },
        },
    },
    {
        'nvim-lua/lsp-status.nvim',
        event = { 'LspAttach' },
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
        event = { 'LspAttach' },
    },
    {
        'ray-x/lsp_signature.nvim',
        event = { 'LspAttach' },
    },
    {
        'neovim/nvim-lspconfig',
        ft = { 'lua', 'rust' },
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
            'williamboman/mason.nvim',
            'folke/neodev.nvim',
            'nvim-lua/lsp-status.nvim',
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function()
            local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview

            function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
                opts = opts or {}
                opts.max_width = 80
                return orig_util_open_floating_preview(contents, syntax, opts, ...)
            end

            vim.diagnostic.config({
                virtual_text = false,
                underline = true,
                signs = true,
            })

            require('neodev').setup()

            local servers = {
                lua_ls = {
                    Lua = {
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                        diagnostics = { enable = false },
                    },
                },
            }

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
            capabilities = vim.tbl_extend('keep', capabilities or {}, require('lsp-status').capabilities)

            local mason_lspconfig = require('mason-lspconfig')
            mason_lspconfig.setup({
                ensure_installed = vim.tbl_keys(servers),
            })
            mason_lspconfig.setup_handlers({
                function(server_name)
                    require('lspconfig')[server_name].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = servers[server_name],
                        filetypes = (servers[server_name] or {}).filetypes,
                    })
                end,
                rust_analyzer = function() end,
            })
        end,
    },
    {
        'simrat39/rust-tools.nvim',
        ft = { 'rust' },
        config = function()
            local adapter

            local ok, mason_registry = pcall(require, 'mason-registry')
            if ok then
                local codelldb = mason_registry.get_package('codelldb')
                local extension_path = codelldb:get_install_path() .. '/extension/'
                local codelldb_path = extension_path .. 'adapter/codelldb'
                local liblldb_path = ''

                if vim.fn.has('win32') then
                    liblldb_path = extension_path .. 'lldb\\bin\\liblldb.dll'
                elseif vim.fn.has('linux') then
                    liblldb_path = extension_path .. 'lldb/lib/liblldb.so'
                end

                if liblldb_path ~= '' then
                    adapter = require('rust-tools.dap').get_codelldb_adapter(
                        codelldb_path,
                        liblldb_path
                    )
                end
            end

            require('rust-tools').setup({
                dap = {
                    adapter = adapter,
                },
                server = {
                    capabilities = capabilities,
                    on_attach = on_attach,
                    standalone = false,
                    checkOnSave = {
                        allFeatures = true,
                        command = 'clippy',
                        extraArgs = { '--no-deps' },
                    },
                },
                tools = {
                    hover_actions = {
                        auto_focus = true,
                    },
                    inlay_hints = {
                        only_current_line = true,
                    },
                },
            })
        end,
    },
}
