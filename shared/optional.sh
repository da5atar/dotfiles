#!/bin/bash

# Notes
sudo curl \
    -L https://raw.githubusercontent.com/da5atar/notes-1/master/notes \
    -o /usr/local/bin/notes && sudo chmod +x /usr/local/bin/notes

# Tera (radio on Internet)
brew tap shinokada/tera
brew install tera

# Bash-it
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
cd ~/.bash_it || exit
source install.sh

# SDK manager
# https://sdkman.io/usage
curl -s "https://get.sdkman.io" | bash

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

# Install Rust.
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install Go.
wget https://golang.org/dl/go1.17.1.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.17.1.linux-amd64.tar.gz
rm go1.17.1.linux-amd64.tar.gz
