## Vim - Language Server

- `K` lsp-hover
- `[g` lsp-previous-diagnostic
- `]g` lsp-next-diagnostic
- `gS` lsp-workspace-symbol-search
- `gd` lsp-definition
- `gi` lsp-implementation
- `gr` lsp-references
- `gs` lsp-document-symbol-search
- `gt` lsp-type-definition
- `<c-f>` lsp#scroll(+4
- `<c-d>` lsp#scroll(-4)
- `<leader>rn` lsp-rename

## Vim - Cursor Movement

- `gt` `:tabn` next tab
- `gT` `:tabp` previous tab
- `[i]gt` - go to tab `[i]`

## Vim - Tabs Management

- `:tabs` - list open tabs
- `:tabm 0` - move current tab to first position
- `:tabm` - move current tab to last position
- `:tabm [i]` - move current tab to position `[i]`

## Vim - Close Tab

- `:tabc` - close current tab
- `:tabo` - close all other tabs

## Vim - New Split

`Pro-Tip:` control splitting directionality by setting `splitright` and `splitbelow` options.

- `<C-w>n` (`:new [file]`) - split horizontaly
- `<C-w>s` (`:split [file]`) - split horizontaly
- `<C-w>v ` (`:vsplit [file]`) - split verticaly

## Vim - Cursor Movement

- `<C-w>w` - next split
- `<C-w>p` - previous split
- `<C-w><Up>` - move above
- `<C-w><Down>` - move bellow
- `<C-w><Left>` - move left
- `<C-w><Right>` - move right

## Vim - Splits Movement

- `<C-w>r` - rotate to the right
- `<C-w>H` - move to the left
- `<C-w>J` - move to the bottom
- `<C-w>K` - move to the top
- `<C-w>L` - move to the right
- `<C-w>T` - (`:tab split`) move split to new tab

## Vim - Resize Split

- `<C-w>p +` - increase height
- `<C-w>p -` - decrease height
- `<C-w>p <` - increase width
- `<C-w>p >` - decrease width

## Vim - Close Split

- `<C-w>c` (`:close`) - close split
- `<C-w>q` (`:q`) - close split and quit file
- `<C-w>o` (`:only`) - close all other splits

## Vim - Window Swap

- Navigate to the window you'd like to move
- Press `<leader>ww`
- Navigate to the window you'd like to swap with
- Press `<leader>ww` again

## Vim - Folds

- `zM` - closes all open folds.
- `zo` - opens folds
- `zc` - closes fold
- `zm` - increases the foldlevel by one.
- `zr` - decreases the foldlevel by one.
- `zR` - decreases the foldlevel to zero -- all folds will be open.
- `zj` - moves the cursor to the next fold.
- `zk` - moves the cursor to the previous fold.
- `za` - toggle a fold at the cursor.
- `zO` - opens all folds at the cursor.
- `zc` - closes a fold under cursor.
- `zd` - deletes the fold at the cursor.
- `zE` - deletes all folds.
- `[z` - move to start of open fold.
- `]z` - move to end of open fold.
- `zf#j` - creates a fold from the cursor down # lines.
- `zf/` - string creates a fold from the cursor to string .

