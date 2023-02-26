vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { '*.rs', 'Cargo.toml', 'Cargo.lock' },
  callback = function()
    -- TODO: add a better error format
    vim.o.efm = table.concat({
      [[%Ethread %.%# panicked at %m\, %f:%l:%c,]],
    }, '')
    vim.o.makeprg = 'cargo'
  end
})
