#!/usr/bin/env bash

# Install apps and binaries with Brew
echo "===================="
echo "Running mac/brew.sh"
echo "====================\n"

source mac/brew.sh

echo "===================="
echo "Done running mac/brew.sh"
echo "====================\n"

# Set npm permissions and install global binaries
echo "===================="
echo "Running shared/npm.sh"
echo "====================\n"

source shared/npm.sh

echo "===================="
echo "Done running shared/npm.sh"
echo "====================\n"

# Create symlinks for dotfiles
echo "===================="
echo "Linking dotfiles"
echo "====================\n"

source link-dotfiles.sh

# Clone repos
echo "===================="
echo "Cloning repos"
echo "====================\n"

source shared/clone-repos.sh

# Configure MacOS defaults.
# You only want to run this once during setup. Additional runs may reset changes you make manually.
echo "===================="
echo "Configuring MAC OS settings"
echo "====================\n"

source mac/macos

echo "===================="
echo "Installing gems"
echo "====================\n"

source mac/iterm/gem

echo "===================="
echo "Setup is done!"
echo "====================\n"



