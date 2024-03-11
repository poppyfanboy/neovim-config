if vim.loader ~= nil then
    vim.loader.enable()
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

math.randomseed(os.time())

require('configs')

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local lazy = require('lazy')

-- Add a custom event that fires after the UI is loaded when opening a file from the CLI like this:
-- `nvim file`.
-- https://github.com/LazyVim/LazyVim/blob/78e6405f90eeb76fdf8f1a51f9b8a81d2647a698/lua/lazyvim/util/plugin.lua#L59

local lazy_event = require('lazy.core.handler.event')
lazy_event.mappings['LazyFile'] = {
    id = 'LazyFile',
    event = 'User',
    pattern = 'LazyFile',
}
lazy_event.mappings['User LazyFile'] = lazy_event.mappings['LazyFile']

local delayed_events = {}
local ui_loaded = false

local function trigger_delayed_events()
    if #delayed_events == 0 or ui_loaded then
        return
    end
    ui_loaded = true
    vim.api.nvim_del_augroup_by_name('lazy_file')

    --- @type table<string,string[]>
    local skips = {}
    for _, event in ipairs(delayed_events) do
        skips[event.event] = skips[event.event] or lazy_event.get_augroups(event.event)
    end

    vim.api.nvim_exec_autocmds('User', { pattern = 'LazyFile', modeline = false })
    for _, event in ipairs(delayed_events) do
        if vim.api.nvim_buf_is_valid(event.buf) then
            lazy_event.trigger({
                event = event.event,
                exclude = skips[event.event],
                data = event.data,
                buf = event.buf,
            })

            if vim.bo[event.buf].filetype then
                lazy_event.trigger({
                    event = 'FileType',
                    buf = event.buf,
                })
            end
        end
    end
    vim.api.nvim_exec_autocmds('CursorMoved', { modeline = false })

    delayed_events = {}
end
trigger_delayed_events = vim.schedule_wrap(trigger_delayed_events)

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufNewFile', 'BufWritePre' }, {
    group = vim.api.nvim_create_augroup('lazy_file', { clear = true }),
    callback = function(event)
        table.insert(delayed_events, event)
        trigger_delayed_events()
    end,
})

lazy.setup('plugins', {
    change_detection = {
        -- Annoying
        notify = false,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                'gzip',
                'netrwPlugin',
                'tarPlugin',
                'tohtml',
                'tutor',
                'zipPlugin',

                -- I use matchup plugin instead
                'matchit',
                'matchparen',
            },
        },
    },
    install = {
        colorscheme = { 'kanagawa', 'default', 'habamax' },
    },
    ui = {
        backdrop = 100,
    },
})
