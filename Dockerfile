# renovate: datasource=docker depName=alpine
ARG ALPINE_VERSION=3.24.4
# renovate: datasource=docker depName=jasonben/rust-apps
ARG RUST_APPS_VERSION=1.0.0
# renovate: datasource=docker depName=jasonben/go-apps
ARG GO_APPS_VERSION=1.0.0
FROM jasonben/go-apps:${GO_APPS_VERSION} AS go-apps
FROM jasonben/rust-apps:${RUST_APPS_VERSION} AS rust-apps
FROM alpine:${ALPINE_VERSION} AS ide-base-image

ENV \
  IDE_USER=ide \
  IDE_HOME=/jasonben/ide

ENV \
  GO_VERSION=1.26.0 \
  GRADLE_VERSION=9.9.1 \
  GROOVY_VERSION=6.0.0 \
  KOTLIN_VERSION=2.4.21 \
  NODE_VERSION=24.5.0 \
  PYTHON_VERSION=3.14.0 \
  RUBY_VERSION=4.0.5 \
  SCALA_VERSION=3.10.1 \
  HOME=$IDE_HOME \
  TERM=tmux-256color \
  LANG=C.UTF-8 \
  SHELL=/bin/zsh \
  EDITOR=nvim \
  GOPATH=$IDE_HOME/go \
  BUNDLE_SILENCE_ROOT_WARNING=1 \
  PSQL_PAGER='pspg -X -b' \
  BASE16_THEME=catppuccin-macchiato \
  TMUX_PLUGIN_MANAGER_PATH=$IDE_HOME/.config/tmux/plugins \
  COC_USER_CONFIG=$IDE_HOME/.nvim/coc/coc-settings.json \
  CLAUDE_CONFIG_DIR=$IDE_HOME/.claude \
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
    mariadb-connector-c-dev \
    musl-dev \
    nasm \
    ncurses \
    pacman \
    pandoc \
    pkgconf \
    poppler \
    postgresql-client \
    libpq-dev \
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
    aws-cli \
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
    gum \
    hcloud \
    highlight \
    httpie \
    jq \
    just \
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
    shellcheck \
    shfmt \
    starship \
    tailscale \
    tmux \
    tree \
    unzip \
    util-linux-misc \
    uv \
    vim \
    watchexec \
    wget \
    yq \
    zoxide \
    zsh \
    && \
  echo "System: installing additional apps using mise" && \
    mise use --global terraform && \
    mise use --global gcloud && \
    rm -rf "$MISE_DATA_DIR/downloads" "$MISE_CACHE_DIR" && \
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
    mkdir -p /etc/doas.d && \
    echo "permit nopass $IDE_USER as root" > /etc/doas.d/doas.conf && \
    chown -c root:root /etc/doas.d/doas.conf && \
    chmod -c 0400 /etc/doas.d/doas.conf && \
  echo "Ruby: Ignore ri and rdoc" && \
    touch "$IDE_HOME/.gemrc" && \
    echo 'gem: --no-document' >> "$IDE_HOME/.gemrc" && \
  echo "Tmux: Generate tmux-256color TERM" && \
    infocmp -x tmux-256color > tmux-256color.src && \
    /usr/bin/tic -x tmux-256color.src && \
  chown -R "$IDE_USER:$IDE_USER" $IDE_HOME

# Language toolchains get their own layer so the build deps and apps layer
# above stays cached when this list changes. apk over mise: prebuilt for musl
# on both amd64 and arm64. Kotlin, Scala and Groovy aren't in apk, and apk's
# Gradle 8 can't run on JDK 25; mise installs those below, on top of this JDK.
RUN \
  echo "System: Installing language toolchains" && \
    apk add --no-cache \
    cargo \
    clang \
    clojure \
    dotnet10-sdk \
    elixir \
    erlang \
    llvm \
    maven \
    ocaml \
    opam \
    openjdk25-jdk \
    R \
    rust \
    zig

# Point JVM tools at the apk JDK. The mise groovy plugin would otherwise run
# `asdf which java` on every mise exec / prompt and error, since mise doesn't
# manage java here.
ENV \
  JAVA_HOME=/usr/lib/jvm/default-jvm \
  ASDF_GROOVY_DISABLE_JAVA_HOME_EXPORT=true

COPY --chmod=755 ./scripts/clone-at /usr/local/bin/clone-at
COPY --chmod=755 ./scripts/duckdb-select /usr/local/bin/duckdb

USER $IDE_USER
WORKDIR $IDE_HOME

# Pinned refs: tags where upstream publishes them, commit SHAs otherwise.
# The "# renovate:" comments drive both Renovate and scripts/bump-refs.
# renovate: datasource=git-refs depName=https://github.com/ohmyzsh/ohmyzsh branch=master
ARG OHMYZSH_REF=6010fb6260f359e71d99ba25f05f9215809b3ed2
# renovate: datasource=github-tags depName=zsh-users/zsh-autosuggestions
ARG ZSH_AUTOSUGGESTIONS_REF=v0.7.1
# renovate: datasource=github-tags depName=zsh-users/zsh-syntax-highlighting
ARG ZSH_SYNTAX_HIGHLIGHTING_REF=0.8.0
# renovate: datasource=git-refs depName=https://github.com/joshskidmore/zsh-fzf-history-search branch=master
ARG ZSH_FZF_HISTORY_SEARCH_REF=35df458f7d9478fa88c74af762dcd296cdfd485d
# renovate: datasource=git-refs depName=https://github.com/base16-project/base16-shell branch=main
ARG BASE16_SHELL_REF=497c34eacade613cd28fa51e98440d336dcc1f80
# renovate: datasource=github-tags depName=kdabir/has
ARG HAS_REF=v1.6.0
# renovate: datasource=github-tags depName=catppuccin/tmux
ARG CATPPUCCIN_TMUX_REF=v2.1.3
# DuckDB is bumped by scripts/bump-refs only: the hashes must change with the
# version, which Renovate can't do. Two CLIs ship: 2.x needs x86-64-v3 (AVX2),
# so 1.x stays for older x86 CPUs; /usr/local/bin/duckdb picks one at runtime.
# duckdb2: sha256 of duckdb-cli-linux-<arch>-musl.tar.gz
ARG DUCKDB_VERSION=2.0.0
ARG DUCKDB_SHA256_AMD64=3285e4083a79955b0606ab799ebc1493087307cdc76b4827308b1a4dcdb371c9
ARG DUCKDB_SHA256_ARM64=59aee3049c335917307f5df1b3722af1335fef99199dc89e8064d1b2838620c7
# duckdb1: sha256 of duckdb_cli-linux-<arch>-musl.gz
ARG DUCKDB1_VERSION=1.5.3
ARG DUCKDB1_SHA256_AMD64=fe6dcb7c259ee8f6ecc0fd72ed0f9ce26d5539cc8d1e141c0b95e2168fd0ff16
ARG DUCKDB1_SHA256_ARM64=1a587a0a8b4d8b9886facccc027a003d9bad1e5236e168fb0f6d39886eb4db63

# hadolint ignore=DL4006
RUN \
  echo "Zsh: Installing ohmyzsh" && \
    clone-at https://github.com/ohmyzsh/ohmyzsh.git "$OHMYZSH_REF" \
      "$IDE_HOME/.oh-my-zsh" \
    && \
  echo "Zsh: Installing auto suggestions" && \
    clone-at https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_AUTOSUGGESTIONS_REF" \
      "$IDE_HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" \
    && \
  echo "Zsh: Installing syntax highlighting" && \
    clone-at https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX_HIGHLIGHTING_REF" \
      "$IDE_HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" \
    && \
  echo "Zsh: Installing zsh-fzf-history-search" && \
    clone-at https://github.com/joshskidmore/zsh-fzf-history-search.git "$ZSH_FZF_HISTORY_SEARCH_REF" \
      "$IDE_HOME/.oh-my-zsh/custom/plugins/zsh-fzf-history-search" \
    && \
  echo "Zsh: Installing base16-shell" && \
    clone-at https://github.com/base16-project/base16-shell.git "$BASE16_SHELL_REF" \
      "$IDE_HOME/.base16-shell" \
    && \
  echo "Random: Install has command" && \
    clone-at https://github.com/kdabir/has.git "$HAS_REF" /tmp/has && \
    doas make -C /tmp/has install \
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
  echo "Go: Installing" && \
    mise use --global go@$GO_VERSION && \
  echo "Kotlin: Installing" && \
    mise use --global kotlin@$KOTLIN_VERSION && \
  echo "Scala: Installing" && \
    mise use --global scala@$SCALA_VERSION && \
  echo "Groovy: Installing" && \
    mise use --global groovy@$GROOVY_VERSION && \
  echo "Gradle: Installing" && \
    mise use --global gradle@$GRADLE_VERSION && \
  echo "Tmux: Installing catppuccin" && \
    mkdir -p "$IDE_HOME/.tmux/plugins/catppuccin" && \
    clone-at https://github.com/catppuccin/tmux.git "$CATPPUCCIN_TMUX_REF" \
      "$IDE_HOME/.tmux/plugins/catppuccin/tmux" \
    && \
  echo "Duckdb: Installing $DUCKDB_VERSION as duckdb2, $DUCKDB1_VERSION as duckdb1" && \
    if [ "$(uname -m)" = "x86_64" ]; then \
      duckdb_arch=amd64 duckdb_sha256="$DUCKDB_SHA256_AMD64" duckdb1_sha256="$DUCKDB1_SHA256_AMD64"; \
    else \
      duckdb_arch=arm64 duckdb_sha256="$DUCKDB_SHA256_ARM64" duckdb1_sha256="$DUCKDB1_SHA256_ARM64"; \
    fi && \
    curl -fsSL -o /tmp/duckdb.tar.gz \
      "https://github.com/duckdb/duckdb/releases/download/v$DUCKDB_VERSION/duckdb-cli-linux-$duckdb_arch-musl.tar.gz" && \
    echo "$duckdb_sha256  /tmp/duckdb.tar.gz" | sha256sum -c - && \
    tar -xzf /tmp/duckdb.tar.gz -C /tmp duckdb && \
    doas install -m 755 /tmp/duckdb /usr/local/bin/duckdb2 && \
    curl -fsSL -o /tmp/duckdb1.gz \
      "https://github.com/duckdb/duckdb/releases/download/v$DUCKDB1_VERSION/duckdb_cli-linux-$duckdb_arch-musl.gz" && \
    echo "$duckdb1_sha256  /tmp/duckdb1.gz" | sha256sum -c - && \
    gunzip /tmp/duckdb1.gz && \
    doas install -m 755 /tmp/duckdb1 /usr/local/bin/duckdb1 \
    && \
  echo "Cleaning up" && \
    mise exec go@$GO_VERSION -- go clean -cache && \
    doas rm -rf /tmp/* && \
    doas rm -rf "$GOPATH/src" && \
    doas rm -rf "$GOPATH/pkg" && \
    doas rm -rf "$IDE_HOME/.cache" && \
    doas rm -rf "$MISE_DATA_DIR/downloads" "$MISE_CACHE_DIR" && \
    doas mkdir -p \
      $IDE_HOME/.config/ide/context/personal/zsh \
      $IDE_HOME/.config/ide/context/work/zsh \
      $IDE_HOME/.tmuxinator \
      $IDE_HOME/.cache \
      $IDE_HOME/.claude \
      $IDE_HOME/.ssh \
      $IDE_HOME/bundle \
      $IDE_HOME/code \
      && \
    doas chown -R ide:ide \
      $IDE_HOME/bundle \
      $IDE_HOME/code \
      $IDE_HOME/.cache \
      $IDE_HOME/.claude \
      $IDE_HOME/.config \
      $IDE_HOME/.ssh \
      $IDE_HOME/.tmuxinator

COPY --from=go-apps   --chown=$IDE_USER:$IDE_USER $IDE_HOME/go $IDE_HOME/go
COPY --from=rust-apps --chown=$IDE_USER:$IDE_USER $IDE_HOME/rust $IDE_HOME/rust
#=====================================================================

FROM ide-base-image AS ide

# renovate: datasource=github-tags depName=tmux-plugins/tpm
ARG TPM_REF=v3.1.0
# renovate: datasource=github-tags depName=junegunn/vim-plug
ARG VIM_PLUG_REF=0.15.0

COPY --chown=$IDE_USER:$IDE_USER ./dotfiles/mise $IDE_HOME/.mise

# Caches are cleared in this same RUN: deleting them in a later layer would
# not shrink this one.
RUN \
  echo "Mise: Installing default packages" && \
    xargs mise exec "node@$NODE_VERSION"     -- npm install -g < "$IDE_HOME/.mise/default-node-packages" && \
    xargs mise exec "python@$PYTHON_VERSION" -- python -m pip install --no-cache-dir < "$IDE_HOME/.mise/default-python-packages" && \
    xargs mise exec "ruby@$RUBY_VERSION"     -- gem install < "$IDE_HOME/.mise/default-ruby-gems" && \
  echo "Mise: Removing old gem versions and package caches" && \
    mise exec "ruby@$RUBY_VERSION" -- gem cleanup && \
    mise exec "node@$NODE_VERSION" -- npm cache clean --force && \
    rm -rf "$(mise exec "ruby@$RUBY_VERSION" -- gem env gemdir)/cache" \
      "$IDE_HOME/.npm" "$IDE_HOME/.cache" "$MISE_CACHE_DIR"

COPY --chown=$IDE_USER:$IDE_USER ./dotfiles/nvim/             $IDE_HOME/.nvim
COPY --chown=$IDE_USER:$IDE_USER ./dotfiles/tmux/tmux.conf    $IDE_HOME/.tmux.conf

RUN \
  echo "Tmux: Installing tmux plugins" && \
    mkdir -p "$IDE_HOME/.tmux/plugins" && \
    clone-at https://github.com/tmux-plugins/tpm.git "$TPM_REF" "$IDE_HOME/.tmux/plugins/tpm" && \
    "$IDE_HOME/.tmux/plugins/tpm/bin/install_plugins" \
    && \
  echo "Neovim: Installing vim-plug" && \
    curl -fLo "$IDE_HOME/.local/share/nvim/site/autoload/plug.vim" \
      --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/$VIM_PLUG_REF/plug.vim" \
    && \
  echo "Neovim: pynvim fix.. reinstall greenlet" && \
    CC=gcc CXX=g++ mise exec "python@$PYTHON_VERSION" -- python -m \
      pip install --no-cache-dir --no-binary=greenlet --force-reinstall greenlet \
    && \
  echo "Neovim: Coc install..." && \
    mise exec "node@$NODE_VERSION" -- npm install --prefix "$IDE_HOME/.nvim/coc/extensions" && \
  echo "Neovim: Plug install..." && \
    nvim -es -u "$IDE_HOME/.nvim/init.lua" -i NONE -c "PlugInstall" -c "qa" && \
  echo "Cleaning up" && \
    mise exec "go@$GO_VERSION" -- go clean -cache && \
    doas rm -rf /tmp/* && \
    doas rm -rf "$GOPATH/src" && \
    doas rm -rf "$GOPATH/pkg" && \
    doas rm -rf "$IDE_HOME/.npm" && \
    doas rm -rf "$IDE_HOME/.cache" && \
    doas rm -rf "$IDE_HOME/go/pkg" && \
    doas chown -R "$IDE_USER:$IDE_USER" "$IDE_HOME/go" && \
    mkdir -p "$GOPATH/src" "$GOPATH/bin" "$IDE_HOME/.cache" && \
  echo "Copying dotfiles"

COPY --chown=$IDE_USER:$IDE_USER ./dotfiles/editorconfig/editorconfig    $IDE_HOME/.editorconfig
COPY --chown=$IDE_USER:$IDE_USER ./dotfiles/git/gitconfig                $IDE_HOME/.gitconfig
COPY --chown=$IDE_USER:$IDE_USER ./dotfiles/git/gitignore                $IDE_HOME/.gitignore
COPY --chown=$IDE_USER:$IDE_USER ./dotfiles/host/bin/ide                 $IDE_HOME/.dotfiles/host/bin/ide
COPY --chown=$IDE_USER:$IDE_USER ./dotfiles/bin                          $IDE_HOME/.dotfiles/bin
COPY --chown=$IDE_USER:$IDE_USER ./dotfiles/prettier/prettierrc.js       $IDE_HOME/.prettierrc.js
COPY --chown=$IDE_USER:$IDE_USER ./dotfiles/ruby/rubocop.yml             $IDE_HOME/.rubocop.yml
COPY --chown=$IDE_USER:$IDE_USER ./dotfiles/ruby/solargraph.yml          $IDE_HOME/.solargraph.yml
COPY --chown=$IDE_USER:$IDE_USER ./dotfiles/tmux/gitmux.conf             $IDE_HOME/.gitmux.conf
COPY --chown=$IDE_USER:$IDE_USER ./dotfiles/usql/usqlrc                  $IDE_HOME/.usqlrc
COPY --chown=$IDE_USER:$IDE_USER ./dotfiles/ranger                       $IDE_HOME/.ranger
COPY --chown=$IDE_USER:$IDE_USER ./dotfiles/lazygit                      $IDE_HOME/.lazygit
COPY --chown=$IDE_USER:$IDE_USER ./dotfiles/zsh                          $IDE_HOME/.zsh
COPY --chown=$IDE_USER:$IDE_USER ./dotfiles/zsh/starship.toml            $IDE_HOME/.starship.toml
COPY --chown=$IDE_USER:$IDE_USER ./dotfiles/zsh/zshenv                   $IDE_HOME/.zshenv
