ARG ALPINE_VERSION=3.23
FROM jasonben/go-apps AS go-apps
FROM jasonben/rust-apps AS rust-apps
FROM alpine:${ALPINE_VERSION} AS ide-base-image

ENV \
  IDE_USER=ide \
  IDE_HOME=/jasonben/ide

ENV \
  NODE_VERSION=24.5.0 \
  PYTHON_VERSION=3.11.11 \
  RUBY_VERSION=3.4.7 \
  HOME=$IDE_HOME \
  TERM=tmux-256color \
  LANG=C.UTF-8 \
  SHELL=/bin/zsh \
  EDITOR=vim \
  GOPATH=$IDE_HOME/go \
  BUNDLE_SILENCE_ROOT_WARNING=1 \
  PSQL_PAGER='pspg -X -b' \
  BASE16_THEME=catppuccin-macchiato \
  TMUX_PLUGIN_MANAGER_PATH=$IDE_HOME/.config/tmux/plugins \
  COC_USER_CONFIG=$IDE_HOME/.nvim/coc/coc-settings.json \
  MISE_GLOBAL_CONFIG_FILE=$IDE_HOME/.mise/config.toml \
  MISE_DATA_DIR=$IDE_HOME/.mise/plugins-and-tool-installs \
  MISE_CONFIG_DIR=$IDE_HOME/.mise/config \
  MISE_STATE_DIR=$IDE_HOME/.mise/state \
  MISE_CACHE_DIR=$IDE_HOME/.mise/cache \
  MISE_ALL_COMPILE=false \
  MISE_NODE_FLAVOR=musl \
  MISE_NODE_GPG_VERIFY=false \
  MISE_NODE_COMPILE=false \
  MISE_NODE_MIRROR_URL=https://unofficial-builds.nodejs.org/download/release/ \
  MISE_NODE_MIRROR_URL_ARM64=https://node-arm64-musl-binaries.cdn.jasonben.com

ENV \
  PATH="$GOPATH/bin:$PATH"

# hadolint ignore=DL4006
RUN \
  echo "System: Installing build deps" && \
    apk update && \
    apk add --no-cache \
    autoconf \
    automake \
    binutils-gold \
    build-base \
    ca-certificates \
    clang \
    coreutils \
    ffmpeg \
    file \
    g++ \
    gcc \
    gcompat \
    glib-dev \
    gnupg \
    hyperfine \
    jpeg \
    libffi-dev \
    libgcc \
    libgit2 \
    libjpeg-turbo-dev \
    libpq \
    libstdc++ \
    libtool \
    libxml2-dev \
    libxslt-dev \
    linux-headers \
    make \
    mariadb-dev \
    musl-dev \
    nasm \
    ncurses \
    pacman \
    pandoc \
    pkgconf \
    poppler \
    postgresql-client \
    postgresql-dev \
    pspg \
    ruby-dev \
    shadow \
    sqlite-dev \
    tiff \
    tzdata \
    unixodbc \
    vips-dev \
    yaml-dev \
    zlib \
    zlib-dev \
    && \
    echo "System: Installing frequently used apps" && \
    apk add --no-cache \
    atuin \
    bash \
    bat \
    bind-tools \
    broot \
    btop \
    ctags \
    curl \
    delta \
    doas \
    docker \
    docker-cli-buildx \
    docker-cli-compose \
    doctl \
    eza \
    fd \
    git \
    github-cli \
    go \
    gum \
    hcloud \
    highlight \
    httpie \
    jq \
    lazydocker \
    less \
    libqalculate \
    miller \
    mise \
    ncdu \
    neovim \
    onefetch \
    openssh-client \
    ripgrep \
    rsync \
    s3fs-fuse \
    shadow \
    shellcheck \
    shfmt \
    starship \
    tailscale \
    the_silver_searcher \
    tmux \
    tree \
    unzip \
    util-linux-misc \
    vim \
    watchexec \
    wget \
    yarn \
    zoxide \
    zsh \
    && \
    apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/community \
    aws-cli \
    && \
  echo "System: Done installing apps" && \
  echo "System: Configuring settings" && \
  echo "System: Changing timezone to US/Central" && \
    cp /usr/share/zoneinfo/US/Central /etc/localtime && \
    echo "US/Central" > /etc/timezone \
    && \
  echo "System: Creating new user: '$IDE_USER'" && \
    addgroup -g 1000 -S $IDE_USER && \
    mkdir -p $IDE_HOME && \
    adduser -D -u 1000 -G $IDE_USER -S $IDE_USER -h $IDE_HOME && \
    usermod -s /bin/zsh $IDE_USER && \
    echo "$IDE_USER:password" | chpasswd && \
    chown -R "$IDE_USER:$IDE_USER" $IDE_HOME && \
    mkdir -p /etc/doas.d && \
    echo "permit nopass $IDE_USER as root" > /etc/doas.d/doas.conf && \
    chown -c root:root /etc/doas.d/doas.conf && \
    chmod -c 0400 /etc/doas.d/doas.conf && \
  echo "Ruby: Ignore ri and rdoc" && \
    touch "$IDE_HOME/.gemrc" && \
    echo 'gem: --no-document' >> "$IDE_HOME/.gemrc" && \
  echo "Tmux: Generate tmux-256color TERM" && \
    infocmp -x tmux-256color > tmux-256color.src && \
    /usr/bin/tic -x tmux-256color.src

USER $IDE_USER
WORKDIR $IDE_HOME

RUN \
  echo "Zsh: Installing ohmyzsh" && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && \
  echo "Zsh: Installing auto suggestions" && \
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git \
      $IDE_HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
    && \
  echo "Zsh: Installing syntax highlighting" && \
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git \
      $IDE_HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
    && \
  echo "Zsh: Installing zsh-fzf-history-search" && \
    git clone --depth=1 https://github.com/joshskidmore/zsh-fzf-history-search.git \
      $IDE_HOME/.oh-my-zsh/custom/plugins/zsh-fzf-history-search \
    && \
  echo "Zsh: Installing base16-shell" && \
    git clone --depth=1 https://github.com/base16-project/base16-shell.git \
      $IDE_HOME/.base16-shell \
    && \
  echo "Random: Install has command" && \
    git clone https://github.com/kdabir/has.git && cd has && doas make install && cd .. && rm -rf has \
    && \
  echo "Python: Installing" && \
    { if [ "$(uname -m)" = "x86_64" ]; then \
        mise use --global python@$PYTHON_VERSION; \
      else \
        export MISE_ALL_COMPILE=true && \
        mise use --global python@$PYTHON_VERSION; \
      fi; } \
    && \
  echo "Ruby: Installing" && \
    mise use --global ruby@$RUBY_VERSION && \
  echo "Node: Installing" && \
    { if [ "$(uname -m)" = "x86_64" ]; then \
        mise use --global node@$NODE_VERSION; \
      else \
        export MISE_ALL_COMPILE=false && \
        export MISE_NODE_MIRROR_URL="$MISE_NODE_MIRROR_URL_ARM64" && \
        mise use --global node@$NODE_VERSION; \
      fi; } \
    && \
  echo "Tmux: Installing catppuccin" && \
    mkdir -p "$IDE_HOME/.tmux/plugins/catppuccin" && \
    git clone -b v2.1.3 https://github.com/catppuccin/tmux.git \
      "$IDE_HOME/.tmux/plugins/catppuccin/tmux" \
    && \
  go clean -cache && \
  doas rm -rf "$GOPATH/src" && \
  doas rm -rf "$GOPATH/pkg" && \
  doas rm -rf "$IDE_HOME/.cache" && \
  doas rm -rf "$IDE_HOME/.mise/.cache" && \
  doas mkdir -p \
    $IDE_HOME/.config/ide/context/personal/zsh \
    $IDE_HOME/.config/ide/context/work/zsh \
    $IDE_HOME/.tmuxinator \
    $IDE_HOME/.cache \
    $IDE_HOME/.ssh \
    && \
  doas chown -R ide:ide \
    $IDE_HOME/.cache \
    $IDE_HOME/.config \
    $IDE_HOME/.ssh \
    $IDE_HOME/.tmuxinator

COPY --from=go-apps $IDE_HOME/go $IDE_HOME/go
COPY --from=rust-apps $IDE_HOME/rust $IDE_HOME/rust
#=====================================================================

FROM ide-base-image AS ide

COPY --chown=$IDE_USER ./dotfiles/mise                                  $IDE_HOME/.mise

RUN \
  echo "Mise: Installing default packages" && \
    cat "$IDE_HOME/.mise/default-ruby-gems" | xargs mise exec ruby@$RUBY_VERSION -- gem install && \
    cat "$IDE_HOME/.mise/default-python-packages" | xargs mise exec python@$PYTHON_VERSION -- python -m pip install && \
    cat "$IDE_HOME/.mise/default-node-packages" | xargs mise exec node@$NODE_VERSION -- npm install -g

COPY --chown=$IDE_USER ./dotfiles/nvim/                                 $IDE_HOME/.nvim
COPY --chown=$IDE_USER ./dotfiles/ruby/rubocop.yml                      $IDE_HOME/.rubocop.yml
COPY --chown=$IDE_USER ./dotfiles/ruby/rubocop.yml                      $IDE_HOME/.rubocop.yml
COPY --chown=$IDE_USER ./dotfiles/ruby/solargraph.yml                   $IDE_HOME/.solargraph.yml
COPY --chown=$IDE_USER ./dotfiles/tmux/tmux.conf                        $IDE_HOME/.tmux.conf
COPY --chown=$IDE_USER ./dotfiles/vim/empty                             $IDE_HOME/.dotfiles/vim/vimrc.local
COPY --chown=$IDE_USER ./dotfiles/vim/prettierrc.js                     $IDE_HOME/.prettierrc.js
COPY --chown=$IDE_USER ./dotfiles/vim/vimrc                             $IDE_HOME/.vimrc
COPY --chown=$IDE_USER ./dotfiles/vim/vimrc.coc                         $IDE_HOME/.dotfiles/vim/vimrc.coc
COPY --chown=$IDE_USER ./dotfiles/vim/vimrc_background                  $IDE_HOME/.vimrc_background
COPY --chown=$IDE_USER ./dotfiles/nvim/coc/coc-settings.json            $IDE_HOME/.nvim/coc-settings.json
COPY --chown=$IDE_USER ./dotfiles/nvim/coc/coc-settings.json            $IDE_HOME/.vim/coc-settings.json
COPY --chown=$IDE_USER ./dotfiles/nvim/coc/package.json                 $IDE_HOME/.nvim/coc/extensions/package.json

# echo "Neovim: Installing helptags that let you use :help <topic> to search documentation" && \
#   NEOVIM_HELPTAGS="$(nvim -c ':helptags ALL' -c ':q')" \
#   && \

RUN \
  echo "Tmux: Installing tmux plugins" && \
    mkdir -p "$IDE_HOME/.tmux/plugins" && \
    git clone https://github.com/tmux-plugins/tpm "$IDE_HOME/.tmux/plugins/tpm" && \
    "$IDE_HOME/.tmux/plugins/tpm/bin/install_plugins" \
    && \
  echo "Vim: Installing vim-plug" && \
    curl -fLo "$IDE_HOME/.vim/autoload/plug.vim" \
      --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && \
  echo "Neovim: Installing vim-plug" && \
    curl -fLo "$IDE_HOME/.local/share/nvim/site/autoload/plug.vim" \
      --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && \
  echo "Neovim: pynvim fix.. reinstall greenlet" && \
    CC=clang mise exec python@$PYTHON_VERSION -- python -m \
      pip install --no-binary=greenlet --force-reinstall greenlet \
    && \
  echo "Cleaning up" && \
    go clean -cache && \
    doas rm -rf "/tmp/*" && \
    doas rm -rf "$GOPATH/src" && \
    doas rm -rf "$GOPATH/pkg" && \
    doas rm -rf "$IDE_HOME/.npm" && \
    doas rm -rf "$IDE_HOME/.cache" && \
    doas rm -rf "$IDE_HOME/go/pkg" && \
    doas chown -R "$IDE_USER:$IDE_USER" "$IDE_HOME/go" && \
    mkdir -p "$GOPATH/src" "$GOPATH/bin" "$IDE_HOME/.cache" && \
    chmod -R 1777 "$GOPATH" && \
  echo "Copying dotfiles"

COPY --chown=$IDE_USER ./dotfiles/                              $IDE_HOME/.dotfiles
COPY --chown=$IDE_USER ./dotfiles/git/gitconfig                 $IDE_HOME/.gitconfig
COPY --chown=$IDE_USER ./dotfiles/git/gitignore                 $IDE_HOME/.gitignore
COPY --chown=$IDE_USER ./dotfiles/tmux/gitmux.conf              $IDE_HOME/.gitmux.conf
COPY --chown=$IDE_USER ./dotfiles/usql/usqlrc                   $IDE_HOME/.usqlrc
COPY --chown=$IDE_USER ./dotfiles/vim/editorconfig              $IDE_HOME/.editorconfig
COPY --chown=$IDE_USER ./dotfiles/zsh/starship.toml             $IDE_HOME/.starship.toml
COPY --chown=$IDE_USER ./dotfiles/zsh/zprofile                  $IDE_HOME/.zprofile
COPY --chown=$IDE_USER ./dotfiles/zsh/zshrc                     $IDE_HOME/.zshrc
