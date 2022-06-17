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
