#!/bin/bash

# Mac and Linux:
# _____________

# Notes
sudo curl \
    -L https://raw.githubusercontent.com/da5atar/notes-1/master/notes \
    -o /usr/local/bin/notes && sudo chmod +x /usr/local/bin/notes

# Homebrew:
# Tera (radio on Internet)
brew tap shinokada/tera
brew install tera

# CLI tool to manage multiple GitHub repositories
brew tap alajmo/mani
brew install mani

# Get public ip
# https://github.com/sindresorhus/public-ip-cli
npm install --global public-ip-cli

# Pyenv-install-latest (deprecated)
git clone https://github.com/momo-lab/pyenv-install-latest.git "$(pyenv root)"/plugins/pyenv-install-latest

# Nerd Fonts
cd "$HOME" && git clone https://github.com/ryanoasis/nerd-fonts
cd nerd-fonts || exit
sudo ./install.sh Hack
sudo ./install.sh FiraCode
cd "$HOME" && rm -rf nerd-fonts

# Pyenv-install-latest (deprecated)
git clone https://github.com/momo-lab/pyenv-install-latest.git "$(pyenv root)"/plugins/pyenv-install-latest

# Nerd Fonts
cd "$HOME" && git clone https://github.com/ryanoasis/nerd-fonts
cd nerd-fonts || exit
sudo ./install.sh Hack
sudo ./install.sh FiraCode
cd "$HOME" && rm -rf nerd-fonts

# Install Rust.
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install Rust Utilities
cargo install bat     # cat with wings
cargo install bottom  # system monitor (htop alternative)
cargo install exa     # ls replacement
cargo install fd-find # find (alternative)
cargo install just    # task runner (make alternative)
cargo install ripgrep # code search (grep)
cargo install tokei   # code stats (lines of code)
cargo install zoxide  # cd replacement

# https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv
git clone "https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv.git" "$ZSH_CUSTOM/plugins/autoswitch_virtualenv"
# Then add this line to your .zshrc. Make sure it is before the line source $ZSH/oh-my-zsh.sh.
# plugins=(autoswitch_virtualenv $plugins)

# Linux:
# _____

# Dropbox
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
# Next, run the Dropbox daemon from the newly created .dropbox-dist folder.
~/.dropbox-dist/dropboxd

# Bash-it
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
cd ~/.bash_it || exit
source install.sh

# Install Docker.
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Install Ruby
sudo apt-get install -y ruby-full

# SDK manager
# https://sdkman.io/usage
curl -s "https://get.sdkman.io" | bash

# Shell formatter shfmt https://github.com/mvdan/sh
sudo apt-get install -y shfmt
