#!/bin/bash

# Dropbox
cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
# Next, run the Dropbox daemon from the newly created .dropbox-dist folder.
~/.dropbox-dist/dropboxd


# Nerd Fonts
cd "$GITHUB_FOLDER" && git clone --depth 1 https://github.com/ryanoasis/nerd-fonts # shallow clone
cd nerd-fonts
sudo ./install.sh Hack
sudo ./install.sh FiraCode
cd "$GITHUB_FOLDER" && rm -rf nerd-fonts

# Notes
sudo curl \
  -L https://raw.githubusercontent.com/da5atar/notes-1/master/notes \
  -o /usr/local/bin/notes && sudo chmod +x /usr/local/bin/notes

# Tera
brew tap shinokada/tera
brew install tera

# Bash-it
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
cd ~/.bash_it
source install.sh 