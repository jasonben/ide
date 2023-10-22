#!/usr/bin/env bash

set -e

echo "**** install custom packages ****" &&
  #apk add --no-cache \
   yay -S --noconfirm \
    docker \
    docker-compose \
    kitty \
    vim \
    tmux \
    ranger \
    ruby \
    zsh \
    bash \
    python

echo "**** install jetbrains mono nerd font ****" &&
  sudo pacman -S yay --noconfirm && yay -S nerd-fonts-jetbrains-mono --noconfirm
# sudo apk add \
#   --no-cache \
#   --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
#   font-jetbrains-mono-nerd

cp -r kitty ~/.config/kitty
cp tmux.conf ~/.tmux.conf
cp tmux.local.conf ~/.tmux.local.conf

# echo "**** install testing packages ****" && \
#     apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
#     i3wm-gaps

# echo "**** install community packages ****" && \
#     apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community \
#     font-jetbrains-mono-nerd

# echo "**** install window manager extras ****" && \
#     apk add --no-cache \
#     i3status \
#     dmenu
