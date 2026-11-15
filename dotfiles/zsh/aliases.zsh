unalias l # defined by oh-my-zsh
local exa_custom='exa --icons --git --color --long --no-permissions --time-style "+%Y/%m/%d"'

alias bcp="rsync -avzu --progress"
alias c="clear"
alias chrome="docker run --rm -it fathyb/carbonyl https://duckduckgo.com"
alias cu="curl --fail -s -L"
alias dc='docker compose'
alias docker-compose='docker compose'
alias docker-stats='docker stats --format "table {{.Name}}\t{{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"'
alias e="nvim"
alias files="du -ah . | grep -v "/$" | sort -rh | fzf"
alias install-docker='curl -sSL https://get.docker.com | sudo sh'
alias kanban="mkdir -p ~/code/kanban/{todo,doing,done} && echo 'simply' > ~/code/kanban/done/create-kanban && tree -C"
alias l="$exa_custom"
alias lazydocker="DOCKER_HOST=http://dockersock:2375 lazydocker"
alias lazygit="lazygit -ucf $HOME/.lazygit/config.yml"
alias lsln='find . -maxdepth 1 -type l -exec ls -l {} +'
alias lt="$exa_custom --tree"
alias maps="npx mapscii"
alias ncdu="ncdu --color dark -rr -x --exclude .git --exclude node_modules --exclude .bundle"
alias nvim="nvim -u $HOME/.nvim/init.lua"
alias pping="prettyping"
alias ranger="ranger --confdir $HOME/.ranger"
alias ruby-dev="gem install colorls bundler pry awesome_print solargraph prettier_print syntax_tree syntax_tree-haml syntax_tree-rbs"
alias speedtest="docker run --rm --net=host tianon/speedtest --accept-license --accept-gdpr"
alias update-arch='sudo pacman -Scc && sudo pacman -Syyu --noconfirm'
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'
alias vi="vim"
alias vultr="docker run -it --rm -e VULTR_API_KEY vultr/vultr-cli:latest"
alias weather="curl https://wttr.in"
alias webserve="ruby -run -ehttpd . -p8000"
alias whois="whois -h whois.networksolutions.com"
alias wtf="docker run -it --rm jasonben/wtfutil"
alias x="tmux kill-server"
