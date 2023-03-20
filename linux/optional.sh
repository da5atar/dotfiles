#!/bin/bash

# Linux Optional Installs
# Dropbox
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
# Next, run the Dropbox daemon from the newly created .dropbox-dist folder.
~/.dropbox-dist/dropboxd

# Nerd Fonts
cd "$HOME" && git clone https://github.com/ryanoasis/nerd-fonts
cd nerd-fonts || exit
sudo ./install.sh Hack
sudo ./install.sh FiraCode
cd "$HOME" && rm -rf nerd-fonts

# Install Rust.
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Rust Utilities
cargo install bat
cargo install bottom
cargo install exa
cargo install fd-find
cargo install ripgrep
cargo install tokei
cargo install zoxide

# Install Go.
wget https://golang.org/dl/go1.17.1.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.17.1.linux-amd64.tar.gz
rm go1.17.1.linux-amd64.tar.gz

# Install Docker.
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Install Ruby
sudo apt-get install -y ruby-full
