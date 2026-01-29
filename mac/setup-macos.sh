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
