```console
#MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMjasonben/                     dddddddd
#MMNOxddddddddddddddddddddddddddddxONMMM    iiii              d::::::d
#Wk;;cllllllllllllllllllllllllllllc;;kWM   i::::i             d::::::d
#K,,0MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0,,KM    iiii              d::::::d
#O':NMMMWNWMMMMMMMMMMMMMMMMMMMMMMMMN:'OM                      d:::::d
#O':XMMMKc:kWMMMMMMMMMMMMMMMMMMMMMMX:'OM  iiiiiii     ddddddddd:::::d     eeeeeeeeeeee
#O':XMMMWKl,:kNMMMMMMMMMMMMMMMMMMMMX:'OM  i:::::i   dd::::::::::::::d   ee::::::::::::ee
#O':XMMMMMW0l,:ONMMMMMMMMMMMMMMMMMMX:'OM   i::::i  d::::::::::::::::d  e::::::eeeee:::::ee
#O':XMMMMMMMW0;.lNMMMMMMMMMMMMMMMMMX:'OM   i::::i d:::::::ddddd:::::d e::::::e     e:::::e
#O':XMMMMMMW0l,:OWMMMMMMMMMMMMMMMMMX:'OM   i::::i d::::::d    d:::::d e:::::::eeeee::::::e
#O':NMMMMWKl,:ONMMMMMMMMMMMMMMMMMMMN:'OM   i::::i d:::::d     d:::::d e:::::::::::::::::e
#O':XMMMXo,:ONMMMMXkddddddddddkXMMMX:'OM   i::::i d:::::d     d:::::d e::::::eeeeeeeeeee
#O':XMMMKxONMMMMMMKdlllllllllldKMMMX:'OM   i::::i d:::::d     d:::::d e:::::::e
#0':XMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMX:'0M  i::::::id::::::ddddd::::::dde::::::::e
#Xc.o0KKKKKKKKKKKKKKKKKKKKKKKKKKKK0o.cXM  i::::::i d:::::::::::::::::d e::::::::eeeeeeee
#MXxc:cccccccccccccccccccccccccccc:cxXMM  i::::::i  d:::::::::ddd::::d  ee:::::::::::::e
#MMMWWNNNNNNNNNNNNNNNNNNNNNNNNNNNNWWMMMM  iiiiiiii   ddddddddd   ddddd    eeeeeeeeeeeeee
```

# Prerequisites

## curl, Docker

```sh
# linux (X86_64 / arm64)
curl -sSL https://get.docker.com | sh
# macOS (arm64)
# curl -O https://desktop.docker.com/mac/main/arm64/Docker.dmg && open Docker.dmg
```

## Security-enhanced proxy for the Docker Socket

```console
git clone https://github.com/jasonben/docker-sock.git && pushd docker-sock && docker compose up -d && popd
```

# Install

```sh
curl https://jasonben.com/ide -fsSL | sh
```

# Run

```console
ide
```

# Preferred terminal emulator

```sh
# Using the default system terminal
# install kitty
curl https://sw.kovidgoyal.net/kitty/installer.sh -fsSL | sh
```

# Documentation (wip)

## Git Aliases

```
  # Used like: `git cam`

  a = add --all
  ai = add -i

  ap = apply
  as = apply --stat
  ac = apply --check

  amr = am --resolved
  ams = am --skip

  b = branch
  ba = branch -a
  bd = branch -d
  bdd = branch -D
  br = branch -r
  bu = !git rev-parse --abbrev-ref --symbolic-full-name "@{u}"
  bs = !git-branch-status

  c = commit
  ca = commit -a
  cam = commit -am
  cem = commit --allow-empty -m
  cd = commit --amend
  ced = commit --allow-empty --amend

  cl = clone
  cld = clone --depth 1
  clg = !sh -c 'git clone git://github.com/$1 $(basename $1)' -
  clgp = !sh -c 'git clone git@github.com:$1 $(basename $1)' -
  clgu = !sh -c 'git clone git@github.com:$(git config --get user.username)/$1 $1' -
  cp = cherry-pick
  cpa = cherry-pick --abort
  cpc = cherry-pick --continue
  d = diff
  dc = diff --cached
  dck = diff --cached --check
  dct = difftool --cached

  fo = fetch origin
  fu = fetch upstream
  fp = format-patch

  fk = fsck

  l = log --oneline
  lg = log --oneline --graph --decorate

  lsf = !git ls-files | grep -i
  m = merge
  ma = merge --abort
  mc = merge --continue
  ms = merge --skip

  o = checkout
  om = checkout master
  ob = checkout -b
  opr = !sh -c 'git fo pull/$1/head:pr-$1 && git o pr-$1'

  pr = prune -v

  ps = push
  psf = push -f
  psu = push -u
  pst = push --tags
  pso = push origin
  psao = push --all origin
  psfo = push -f origin
  psuo = push -u origin

  psom = push origin master
  psaom = push --all origin master
  psfom = push -f origin master
  psuom = push -u origin master
  psoc = !git push origin $(git bc)
  psaoc = !git push --all origin $(git bc)
  psfoc = !git push -f origin $(git bc)
  psuoc = !git push -u origin $(git bc)
  psdc = !git push origin :$(git bc)

  pl = pull
  pb = pull --rebase

  plo = pull origin
  pbo = pull --rebase origin
  plom = pull origin master
  ploc = !git pull origin $(git bc)
  pbom = pull --rebase origin master
  pboc = !git pull --rebase origin $(git bc)

  plu = pull upstream
  plum = pull upstream master
  pluc = !git pull upstream $(git bc)
  pbum = pull --rebase upstream master
  pbuc = !git pull --rebase upstream $(git bc)

  rb = rebase
  rba = rebase --abort
  rbc = rebase --continue
  rbi = rebase --interactive
  rbs = rebase --skip

  re = reset
  rh = reset HEAD
  reh = reset --hard
  rem = reset --mixed
  res = reset --soft
  rehh = reset --hard HEAD
  remh = reset --mixed HEAD
  resh = reset --soft HEAD
  rehom = reset --hard origin/master

  r = remote
  ra = remote add
  rr = remote rm
  rv = remote -v
  rn = remote rename
  rp = remote prune
  rs = remote show
  rao = remote add origin
  rau = remote add upstream
  rro = remote remove origin
  rru = remote remove upstream
  rso = remote show origin
  rsu = remote show upstream
  rpo = remote prune origin
  rpu = remote prune upstream
  rmf = rm -f
  rmrf = rm -r -f
  s = status
  sb = status -s -b
  sa = stash apply
  sc = stash clear
  sd = stash drop
  sl = stash list
  sp = stash pop
  ss = stash save
  ssk = stash save -k
  sw = stash show
  st = !git stash list | wc -l 2>/dev/null | grep -oEi '[0-9][0-9]*'
  t = tag
  td = tag -d
  w = show
  wp = show -p
  wr = show -p --no-color
  svnr = svn rebase
  svnd = svn dcommit
  svnl = svn log --oneline --show-commit
  subadd = !sh -c 'git submodule add git://github.com/$1 $2/$(basename $1)' -
  subrm = !sh -c 'git submodule deinit -f -- $1 && rm -rf .git/modules/$1 && git rm -f $1' -
  subup = submodule update --init --recursive
  subpull = !git submodule foreach git pull --tags -f origin master
  assume = update-index --assume-unchanged
  unassume = update-index --no-assume-unchanged
  assumed = !git ls -v | grep ^h | cut -c 3-
  unassumeall = !git assumed | xargs git unassume
  assumeall = !git status -s | awk {'print $2'} | xargs git assume
  bump = !sh -c 'git commit -am \"Version bump v$1\" && git psuoc && git release $1' -
  release = !sh -c 'git tag v$1 && git pst' -
  unrelease = !sh -c 'git tag -d v$1 && git pso :v$1' -
  merged = !sh -c 'git o master && git plom && git bd $1 && git rpo' -
  aliases = !git config -l | grep alias | cut -c 7-
  snap = !git stash save 'snapshot: $(date)' && git stash apply 'stash@{0}'
  bare = !sh -c 'git symbolic-ref HEAD refs/heads/$1 && git rm --cached -r . && git clean -xfd' -
  whois = !sh -c 'git log -i -1 --author=\"$1\" --pretty=\"format:%an <%ae>\"' -
  serve = daemon --reuseaddr --verbose --base-path=. --export-all ./.git
  behind = !git rev-list --left-only --count $(git bu)...HEAD
  ahead = !git rev-list --right-only --count $(git bu)...HEAD
  ours = "!f() { git checkout --ours $@ && git add $@; }; f"
  theirs = "!f() { git checkout --theirs $@ && git add $@; }; f"
  subrepo = !sh -c 'git filter-branch --prune-empty --subdirectory-filter $1 master' -
  human = name-rev --name-only --refs=refs/heads/*
```

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

## Tmux - New Tab

- `:tabnew` - new blank tab
- `:tabedit [file]` - open file in tab

## Tmux - General

- `todo`

# Troubleshooting macOS problems

```sh
# on macOS install tmux-256 color term info file so things work as expected
/opt/homebrew/Cellar/ncurses/6.3/bin/infocmp -x tmux-256color > tmux-256color.src
sudo /usr/bin/tic -x tmux-256color.src

# install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$(whoami)/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

# Helpful Links

- [1pw-cli-todo](https://developer.1password.com/docs/cli/get-started)
- [bandwhich](https://github.com/imsnif/bandwhich)
- [fx](https://github.com/antonmedv/fx)
- [glow](https://github.com/charmbracelet/glow)
- [gron](https://github.com/tomnomnom/gron)
- [gum](https://github.com/charmbracelet/gum)
- [has](https://github.com/kdabir/has)
- [how2](https://github.com/santinic/how2)
- [libqalculate](https://github.com/Qalculate/libqalculate)
- [np](https://github.com/sindresorhus/np)
- [ots-todo](https://github.com/sniptt-official/ots)
- [release-it](https://github.com/release-it/release-it)
- [release-todo](https://github.com/vercel/release)
- [rename](https://github.com/jhotmann/node-rename-cli/tree/master)
- [semantic-release-todo](https://github.com/semantic-release/semantic-release)
- [todo-yank](https://github.com/mptre/yank)
- [up](https://github.com/akavel/up)
- [vim-resize-splits-easily](http://vim.wikia.com/wiki/Resize_splits_more_quickly)
- [vim-resize-splits-faster](http://robots.thoughtbot.com/post/48275867281/vim-splits-move-faster-and-more-naturally)
- [vim-split-window-and-tabs](http://codeincomplete.com/posts/2011/2/14/split_windows_and_tabs_in_vim/)
- [vim-using-tab-pages](http://vim.wikia.com/wiki/Using_tab_pages)

# TODO

- Spawn a VPS on vultr, do, hetzner, etc..
- doctl create ...
- vultr-cli ...
- hetzner-cli ...
- curl https://jasonben.com/kitty -fsSL | sh
