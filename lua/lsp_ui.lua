-- This
-- https://github.com/neovim/neovim/blob/4b029163345333a2c6975cd0dace6613b036ae47/runtime/lua/vim/lsp/util.lua
-- https://github.com/neovim/neovim/blob/4b029163345333a2c6975cd0dace6613b036ae47/runtime/lua/vim/lsp/handlers.lua
-- but without markdown treesitter highlight for signature help and hover floating windows.

local M = {}

local function npcall(fn, ...)
    local status, result = pcall(fn, ...)
    if not status then
        return
    else
        return result
    end
end

local function find_window_by_var(name, value)
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if npcall(vim.api.nvim_win_get_var, win, name) == value then
            return win
        end
    end
end

local function list_contains(t, value)
    for _, v in ipairs(t) do
        if v == value then
            return true
        end
    end

    return false
end

local function close_preview_window(winnr, bufnrs)
    vim.schedule(function()
        if bufnrs and list_contains(bufnrs, vim.api.nvim_get_current_buf()) then
            return
        end

        local augroup = 'preview_window_' .. winnr
        pcall(vim.api.nvim_del_augroup_by_name, augroup)
        pcall(vim.api.nvim_win_close, winnr, true)
    end)
end

local function close_preview_autocmd(events, winnr, bufnrs)
    local augroup = vim.api.nvim_create_augroup('preview_window_' .. winnr, {
        clear = true,
    })

    vim.api.nvim_create_autocmd('BufEnter', {
        group = augroup,
        callback = function()
            close_preview_window(winnr, bufnrs)
        end,
    })

    if #events > 0 then
        vim.api.nvim_create_autocmd(events, {
            group = augroup,
            buffer = bufnrs[2],
            callback = function()
                close_preview_window(winnr)
            end,
        })
    end
end

--- @param contents string[]
function M.open_floating_preview(contents, syntax, opts)
    opts = opts or {}
    opts.wrap = opts.wrap ~= false
    opts.focus = opts.focus ~= false
    opts.close_events = opts.close_events or { 'CursorMoved', 'CursorMovedI', 'InsertCharPre' }
    opts.max_width = opts.max_width or 80
    opts.max_height = opts.max_height or 25

    local bufnr = vim.api.nvim_get_current_buf()

    if opts.focus_id and opts.focusable ~= false and opts.focus then
        local current_winnr = vim.api.nvim_get_current_win()

        if npcall(vim.api.nvim_win_get_var, current_winnr, opts.focus_id) then
            vim.api.nvim_command('wincmd p')
            return bufnr, current_winnr
        end

        local win = find_window_by_var(opts.focus_id, bufnr)
        if win and vim.api.nvim_win_is_valid(win) and vim.fn.pumvisible() == 0 then
            vim.api.nvim_set_current_win(win)
            vim.api.nvim_command('stopinsert')
            return vim.api.nvim_win_get_buf(win), win
        end
    end

    local existing_float = npcall(vim.api.nvim_buf_get_var, bufnr, 'lsp_floating_preview')
    if existing_float and vim.api.nvim_win_is_valid(existing_float) then
        vim.api.nvim_win_close(existing_float, true)
    end

    local width = 0
    local height = 0

    if syntax == 'markdown' then
        local prev_line_was_separator = true

        for _, line in ipairs(contents) do
            local line_width = vim.fn.strdisplaywidth(line:gsub('%z', '\n'))

            width = math.max(line_width, width)

            local current_line_is_separator = #line == 0
                or line == '---'
                or string.sub(line, 1, 3) == '```'

            if not (current_line_is_separator and prev_line_was_separator) then
                height = height + math.max(math.ceil(line_width / opts.max_width), 1)
            end

            prev_line_was_separator = current_line_is_separator
            if line == '---' then
                prev_line_was_separator = false
            end
        end

        if prev_line_was_separator then
            height = height - 1
        end
    else
        for _, line in ipairs(contents) do
            local line_width = vim.fn.strdisplaywidth(line:gsub('%z', '\n'))

            width = math.max(line_width, width)
            height = height + math.max(math.ceil(line_width / opts.max_width), 1)
        end
    end

    width = math.min(width, vim.api.nvim_win_get_width(0), opts.max_width)
    height = math.min(height, vim.api.nvim_win_get_height(0), opts.max_height)

    local float_option = vim.lsp.util.make_floating_popup_options(width, height, opts)

    local floating_bufnr = vim.api.nvim_create_buf(false, true)
    vim.bo[floating_bufnr].syntax = 'markdown'

    if syntax == 'markdown' then
        vim.lsp.util.stylize_markdown(floating_bufnr, contents, opts)
    else
        vim.api.nvim_buf_set_lines(floating_bufnr, 0, -1, true, contents)
    end

    local floating_winnr = vim.api.nvim_open_win(floating_bufnr, false, float_option)

    vim.wo[floating_winnr].foldenable = false
    vim.wo[floating_winnr].wrap = opts.wrap
    vim.bo[floating_bufnr].modifiable = false
    vim.bo[floating_bufnr].bufhidden = 'wipe'

    vim.api.nvim_buf_set_keymap(floating_bufnr, 'n', 'q', '<cmd>bdelete<cr>', {
        silent = true,
        noremap = true,
        nowait = true,
    })
    close_preview_autocmd(opts.close_events, floating_winnr, { floating_bufnr, bufnr })

    if opts.focus_id then
        vim.api.nvim_win_set_var(floating_winnr, opts.focus_id, bufnr)
    end
    vim.api.nvim_buf_set_var(bufnr, 'lsp_floating_preview', floating_winnr)

    return floating_bufnr, floating_winnr
end

function M.signature_help(_, result, ctx, config)
    config = config or {}
    config.focus_id = ctx.method
    if vim.api.nvim_get_current_buf() ~= ctx.bufnr then
        return
    end

    if not (result and result.signatures and result.signatures[1]) then
        print('No signature help available')
        return
    end

    local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
    local triggers =
        vim.tbl_get(client.server_capabilities, 'signatureHelpProvider', 'triggerCharacters')

    local lines = {}
    local hl = {}

    local active_signature = result.activeSignature or 0
    if active_signature >= #result.signatures or active_signature < 0 then
        active_signature = 0
    end

    local signature = result.signatures[active_signature + 1]
    if not signature then
        return
    end

    local label = signature.label

    vim.list_extend(lines, vim.split(label, '\n', { plain = true, trimempty = true }))
    if signature.documentation then
        signature.documentation = { kind = 'plaintext', value = signature.documentation }
    end

    if signature.parameters and #signature.parameters > 0 then
        local active_parameter = (signature.activeParameter or result.activeParameter or 0)
        if active_parameter < 0 then
            active_parameter = 0
        end

        if active_parameter >= #signature.parameters then
            active_parameter = #signature.parameters - 1
        end

        local parameter = signature.parameters[active_parameter + 1]
        if parameter and parameter.label then
            if type(parameter.label) == 'table' then
                hl = parameter.label
            else
                local offset = 1

                for _, t in ipairs(triggers or {}) do
                    local trigger_offset = signature.label:find(t, 1, true)
                    if trigger_offset and (offset == 1 or trigger_offset < offset) then
                        offset = trigger_offset
                    end
                end

                for p, param in pairs(signature.parameters) do
                    offset = signature.label:find(param.label, offset, true)
                    if not offset then
                        break
                    end
                    if p == active_parameter + 1 then
                        hl = { offset - 1, offset + #parameter.label - 1 }
                        break
                    end
                    offset = offset + #param.label + 1
                end
            end
        end
    end

    if not lines or vim.tbl_isempty(lines) then
        print('No signature help available')
        return
    end

    local fbuf, fwin = M.open_floating_preview(lines, 'plaintext', config)

    if hl and #hl == 2 then
        vim.api.nvim_buf_add_highlight(fbuf, -1, 'LspSignatureActiveParameter', 0, unpack(hl))
    end

    return fbuf, fwin
end

function M.hover(_, result, ctx, config)
    config = config or {}
    config.focus_id = ctx.method

    if vim.api.nvim_get_current_buf() ~= ctx.bufnr then
        return
    end

    if not (result and result.contents) then
        vim.notify('No information available')
        return
    end

    local contents = vim.lsp.util.convert_input_to_markdown_lines(result.contents)

    if vim.tbl_isempty(contents) then
        vim.notify('No information available')
        return
    end

    return M.open_floating_preview(contents, 'markdown', config)
end

return M
