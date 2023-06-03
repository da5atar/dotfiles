#!/usr/bin/env bash
# shellcheck disable=SC1091

# Install apps and binaries with Brew
echo "===================="
echo "Running mac/brew.sh"
printf "====================\n"

source mac/brew.sh

echo "===================="
echo "Done running mac/brew.sh"
printf "====================\n"

# Set npm permissions and install global binaries
echo "===================="
echo "Running shared/npm.sh"
printf "====================\n"

source shared/npm.sh

echo "===================="
echo "Done running shared/npm.sh"
printf "====================\n"

# Create symlinks for dotfiles
echo "===================="
echo "Linking dotfiles"
printf "====================\n"

source link-dotfiles.sh

# Clone repos
echo "===================="
echo "Cloning repos"
printf "====================\n"

# source shared/clone-repos.sh

# Configure MacOS defaults.
# You only want to run this once during setup. Additional runs may reset changes you make manually.
echo "===================="
echo "Configuring MAC OS settings"
printf "====================\n"

source mac/macos

echo "===================="
echo "Installing gems"
printf "====================\n"

source mac/iterm/gem

echo "===================="
echo "Setup is done!"
printf "====================\n"
