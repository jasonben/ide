alias chrome="docker run --rm -it fathyb/carbonyl https://duckduckgo.com"
alias wtf="docker run -it --rm jasonben/wtfutil"
alias vultr="docker run -it --rm -e VULTR_API_KEY vultr/vultr-cli:latest"
alias weather="curl https://wttr.in"
alias maps="npx mapscii"
alias news="curl --silent https://us.getnews.tech | less"
alias x="tmux kill-server"
alias ranger="ranger --datadir $HOME/.dotfiles/ranger"
alias lazygit="lazygit -ucf $HOME/.dotfiles/lazygit/config.yml"
alias docker-compose='docker compose'
alias ,,update="\
  mkdir -p ~/.home/.config/kitty && \
  mkdir -p ~/.home/.config/ide && \
  cp ~/.dotfiles/host/kitty/kitty.conf $HOME/.home/.config/kitty/kitty.conf && \
  cp ~/.dotfiles/host/bin/ide  $HOME/.home/.local/bin/ide && \
  cp ~/.dotfiles/host/tmux/tmux.conf $HOME/.home/.tmux.conf && \
  cp ~/.dotfiles/host/tmux/tmux.local.conf $HOME/.home/.tmux.local.conf && \
  echo ' ide has been updated '"
alias cu="curl --fail -s -L"
alias ruby-dev="gem install colorls bundler pry awesome_print solargraph prettier_print syntax_tree syntax_tree-haml syntax_tree-rbs"
alias ncdu="ncdu --color dark -rr -x --exclude .git --exclude node_modules --exclude .bundle"
alias pping="prettyping"
alias webserve="ruby -run -ehttpd . -p8000"
alias e="vim"
alias vi="vim"
alias yt="mpsyt"
alias glances="docker run -v /var/run/docker.sock:/var/run/docker.sock:ro --pid host -it docker.io/nicolargo/glances"
alias ctop="docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock quay.io/vektorlab/ctop:latest"
alias files="du -ah . | grep -v "/$" | sort -rh | fzf"
alias docker-stats='docker stats --format "table {{.Name}}\t{{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"'
alias bi="gem install bundler; bundle install --jobs=4"
alias speedtest="docker run --rm --net=host tianon/speedtest --accept-license"
alias update='sudo pacman -Scc && sudo pacman -Syyu --noconfirm'
alias c="clear"
alias whois="whois -h whois.networksolutions.com"
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'
alias lsln="ls -l `find . -maxdepth 1 -type l -print`"
alias bcp="rsync -avzu --progress"
alias dc='docker compose'
alias install-docker='curl -sSL https://get.docker.com | sudo sh'
alias cx="chmod +x"
alias kanban="mkdir -p ~/code/kanban && cd ~/code/kanban && tree -C"
unalias l # defined by oh-my-zsh
local exa_custom='exa --icons --git --color --long --git-ignore --no-permissions --time-style "+%Y/%m/%d"'
alias l="$exa_custom"
alias lt="$exa_custom --tree"
