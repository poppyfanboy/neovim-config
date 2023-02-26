if vim.fn.has('win32') then
  vim.o.shell = vim.fn.executable('pwsh') and 'pwsh' or 'powershell'
  vim.o.shellcmdflag = table.concat({
    '-NoLogo',
    '-NoProfile',
    '-ExecutionPolicy', 'RemoteSigned',
    '-Command', '[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;',
  }, ' ')
  vim.o.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  vim.o.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  vim.o.shellquote = ''
  vim.o.shellxquote = ''
end
