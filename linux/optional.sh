#!/bin/bash

# Linux Optional Installs
# Dropbox
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
# Next, run the Dropbox daemon from the newly created .dropbox-dist folder.
~/.dropbox-dist/dropboxd

# Nerd Fonts
cd $HOME && git clone https://github.com/ryanoasis/nerd-fonts
cd nerd-fonts
sudo ./install.sh Hack
sudo ./install.sh FiraCode
cd "$HOME" && rm -rf nerd-fonts
