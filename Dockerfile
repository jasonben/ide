ARG IDE_BASE_IMAGE
FROM ${IDE_BASE_IMAGE}

COPY --chown=$IDE_USER ./dotfiles/vim/init.vim            /etc/xdg/nvim/sysinit.vim
COPY --chown=$IDE_USER ./dotfiles/vim/vimrc               $IDE_HOME/.vimrc
COPY --chown=$IDE_USER ./dotfiles/vim/vimrc.coc           $IDE_HOME/.dotfiles/vim/vimrc.coc
COPY --chown=$IDE_USER ./dotfiles/vim/empty               $IDE_HOME/.dotfiles/vim/vimrc.local
COPY --chown=$IDE_USER ./dotfiles/vim/vimrc_background    $IDE_HOME/.vimrc_background
COPY --chown=$IDE_USER ./dotfiles/vim/prettierrc.js       $IDE_HOME/.prettierrc.js
COPY --chown=$IDE_USER ./dotfiles/ruby/rubocop.yml        $IDE_HOME/.rubocop.yml
COPY --chown=$IDE_USER ./dotfiles/ruby/solargraph.yml     $IDE_HOME/.solargraph.yml
COPY --chown=$IDE_USER ./dotfiles/tmux/tmux.conf          $IDE_HOME/.tmux.conf

RUN \
  echo "%%%%%%%%%%%%%%===> Tmux: Installing tmux plugins" && \
    mkdir -p "$IDE_HOME/.tmux/plugins" && \
    git clone https://github.com/tmux-plugins/tpm "$IDE_HOME/.tmux/plugins/tpm" && \
    "$IDE_HOME/.tmux/plugins/tpm/bin/install_plugins" \
    && \
  echo "%%%%%%%%%%%%%%===> Vim: Installing plugins" && \
    VIM_PLUG_INSTALL="$(vim +'PlugInstall --sync' +qa >/dev/null 2>/dev/null)" \
    && \
  echo "%%%%%%%%%%%%%%===> Vim: Installing helptags" && \
    VIM_HELPTAGS="$(vim -c ':helptags ALL' -c ':q')" && \
  echo "%%%%%%%%%%%%%%===> Config: Git" && \
    git config --global core.excludesfile "$IDE_HOME/.gitignore" && \
  echo "%%%%%%%%%%%%%%===> Config: Copying dotfiles" && \
    go clean -cache && \
    doas rm -rf "$GOPATH/src" && \
    doas rm -rf "$GOPATH/pkg" && \
    doas rm -rf "$IDE_HOME/.cache" && \
    mkdir -p "$GOPATH/src" "$GOPATH/bin" "$IDE_HOME/.cache" && chmod -R 1777 "$GOPATH"

COPY --chown=$IDE_USER ./code                           $IDE_HOME/code
COPY --chown=$IDE_USER ./dotfiles/git/gitconfig         $IDE_HOME/.gitconfig
COPY --chown=$IDE_USER ./dotfiles/git/gitignore         $IDE_HOME/.gitignore
COPY --chown=$IDE_USER ./dotfiles/vim/coc-settings.json $IDE_HOME/.vim/coc-settings.json
COPY --chown=$IDE_USER ./dotfiles/vim/editorconfig      $IDE_HOME/.editorconfig
COPY --chown=$IDE_USER ./dotfiles/zsh/zprofile          $IDE_HOME/.zprofile
COPY --chown=$IDE_USER ./dotfiles/zsh/zshrc             $IDE_HOME/.zshrc
COPY --chown=$IDE_USER ./dotfiles/                      $IDE_HOME/.dotfiles
COPY --chown=$IDE_USER ./dotfiles/zsh/starship.toml     $IDE_HOME/.starship.toml
COPY --chown=$IDE_USER ./dotfiles/usql/usqlrc           $IDE_HOME/.usqlrc
