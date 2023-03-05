# neovim config

## keymaps

leader key = `space`

### buffers

- `<m-p>` / `<m-n>` &mdash; previous / next buffer

### files

- `<leader>et` &mdash; toggle file explorer
- `<leader>ef` &mdash; focus on file explorer
- `<leader>ff` &mdash; fuzzy search file by name
- `<leader>fhf` &mdash; same as the preivous one but include the hidden files
- `<leader>fg` &mdash; grep
- `<leader>fb` &mdash; find opened buffer by the file name

### terminal

- `<leader>t1`, `<leader>t2` &mdash; toggle one of the two terminals at the bottom of the screen
  some afsa saf
- `<leader>tf` &mdash; toggle the floating terminal (`<c-w>c` to close)
- `<leader>tt` &mdash; toggle all terminals
- `<esc>` &mdash; exit terminal's insert mode
- `<c-w>` + _movement keys_ to navigate

### LSP

- `gd` &mdash; go to definition
- `<c-k>` &mdash; trigger signature help

### completion

- default vim key bindings like `<c-n>`, `<c-p>`, `<c-e>`
- `<c-space>` &mdash; confirm completion
- `<c-q>` &mdash; trigger completion

### snippets

- `<tab>` &mdash; jump forward
- `<s-tab>` &mdash; jump backward

### misc

- `<leader>cd` &mdash; cd into the directory of the opened file
- `<c-l>` &mdash; switch between russian and english layouts
- `gc` and `gcc` &mdash; comment

### useful vanilla vim stuff

- `cgn` &mdash; change next search item
- `=` + text object &mdash; fix code indentation
- `gw` or `gq` + text object &mdash; reformat lines to be no longer than 100 characters
- `<c-o>` &mdash; go from insert mode to normal mode for a single command
- `<c-f>` while in command mode &mdash; open a split with the commands history

### neovide specific

- `<leader>fs` &mdash; toggle fullscreen
