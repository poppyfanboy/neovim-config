local M = {}

M.too_many_lines = 5000
M.too_large_for_treesitter = 140 * 1024
M.way_too_large = 5 * 1024 * 1024

M.path_separator = '/'
if vim.fn.has('win32') == 1 then
    M.path_separator = '\\'
end

M.diagnostic_signs = {
    text = {
        [vim.diagnostic.severity.ERROR] = ' ',
        [vim.diagnostic.severity.WARN] = ' ',
        [vim.diagnostic.severity.HINT] = '󰌶 ',
        [vim.diagnostic.severity.INFO] = ' ',
    },
}

function M.refresh_statusline()
    local ok, lualine = pcall(require, 'lualine')
    if ok then
        lualine.refresh()
    end
end

--- @param shown boolean
function M.toggle_winbar(shown)
    local ok, barbecue_ui = pcall(require, 'barbecue.ui')
    if ok then
        barbecue_ui.toggle(shown)
    end
end

return M
