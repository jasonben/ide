#ZSH_THEME="powerlevel10k/powerlevel10k"
eval "$(starship init zsh)"

plugins=(\
  zsh-syntax-highlighting \
  zsh-autosuggestions
  # zsh-fzf-history-search
)

DISABLE_AUTO_UPDATE="true"
ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh
BASE16_SHELL=$HOME/.base16-shell
source "$BASE16_SHELL/profile_helper.sh"
