source $ZDOTDIR/env.zsh
source $ZDOTDIR/functions.zsh
source $ZDOTDIR/path.zsh
source $ZDOTDIR/framework.zsh
source $ZDOTDIR/aliases.zsh
source $ZDOTDIR/fzf-git.zsh

[ -f ~/.config/ide/context/personal/zsh/aliases.zsh ] && \
  source ~/.config/ide/context/personal/zsh/aliases.zsh

_has() {
  return $( whence $1 >/dev/null )
}

if _has fzf && _has rg; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
fi

bindkey -s '^[t' 'file=$(fzf-tmux --exit-0); [[ ! -z "$file" ]] && vim "$file"\n'

eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"
eval "$(mise activate zsh)"

# broot --set-install-state installed
function br {
    local cmd cmd_file code
    cmd_file=$(mktemp)
    if broot --outcmd "$cmd_file" "$@"; then
        cmd=$(<"$cmd_file")
        command rm -f "$cmd_file"
        eval "$cmd"
    else
        code=$?
        command rm -f "$cmd_file"
        return "$code"
    fi
}
