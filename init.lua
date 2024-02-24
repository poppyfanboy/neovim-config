if vim.loader ~= nil then
    vim.loader.enable()
end

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
require('lazy').setup('plugins', {
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
        colorscheme = { 'kanagawa' },
    },
})
