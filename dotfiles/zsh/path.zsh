# System dirs (/usr/local/bin, /usr/bin, /bin, ...) come from the image's
# default PATH; only user-level dirs are prepended here.
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/rust/bin:$PATH"
export PATH="$HOME/.dotfiles/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PNPM_HOME:$PATH"
typeset -U path # drop duplicate entries
