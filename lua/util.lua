local M = {}

-- Used to disable Treesitter for large files (too laggy)
M.large_file_lines_count = 5000

M.path_separator = '/'
if vim.fn.has('win32') == 1 then
    M.path_separator = '\\'
end

function M.refresh_statusline()
    local ok, lualine = pcall(require, 'lualine')
    if ok then
        lualine.refresh()
    end
end

--- Barbecue sometimes messes up git diff view
--- @param shown boolean?
function M.toggle_winbar(shown)
    local ok, barbecue_ui = pcall(require, 'barbecue.ui')
    if ok then
        barbecue_ui.toggle(shown)
    end
end

function M.contains(needle, haystack)
    for _, v in ipairs(haystack) do
        if v == needle then
            return true
        end
    end
    return false
end

return M
