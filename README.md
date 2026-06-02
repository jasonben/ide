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

# Install

```console
curl https://jasonben.com/ide -fsSL | sh
```

# Run

```console
ide
```

# Preferred font - JetBrainsMono Nerd Font Mono

[Download](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip)

# Prerequisites

## Install curl and docker

### Linux
```sh
curl -sSL https://get.docker.com | sh
```

#### Fedora
```sh
sudo dnf -y install curl dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y docker-ce
sudo systemctl enable docker
sudo systemctl start docker
```
### macOS
```sh
brew install --cask docker-desktop
```

# Documentation

[docs](./docs)

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
