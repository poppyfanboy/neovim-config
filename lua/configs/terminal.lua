if vim.fn.has('win32') == 1 and vim.fn.executable('pwsh') == 1 then
  vim.o.shell = 'pwsh'
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
