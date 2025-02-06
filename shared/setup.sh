#!/bin/bash

# Update and upgrade apt
sudo apt update && sudo apt upgrade -y

# Install binaries via apt
echo "===================="
echo "Running linux/apt.sh"
printf "====================\n"

source linux/apt.sh

echo "===================="
echo "Done running linux/apt.sh"
printf "====================\n"

# Set npm permissions and install npm binaries
echo "===================="
echo "Running shared/npm.sh"
printf "====================\n"

source shared/npm.sh

echo "===================="
echo "Done running shared/npm.sh"
printf "====================\n"

# Install apps and binaries with Brew
echo "===================="
echo "Running linux/linuxbrew.sh"
printf "====================\n"

# if architecture is intel
if [[ $(uname -m) == "x86_64" ]]; then
  source linux/linuxbrew.sh
  echo "===================="
  echo "Done running linux/linuxbrew.sh"
  printf "====================\n"
else # if architecture is arm
  echo "===================="
  echo "Skipping linuxbrew.sh - ARM arch detected"
  printf "====================\n"
fi

# Install apps and binaries with Snap
# echo "===================="
# echo "Running linux/snap.sh"
# printf "====================\n"

# source linux/snap.sh

# echo "===================="
# echo "Done running linux/snap.sh"
# printf "====================\n"

# Install apps and binaries with Flatpak
# echo "===================="
# echo "Running linux/flatpak.sh"
# printf "====================\n"

# # source linux/flatpak.sh

# echo "===================="
# echo "Done running linux/flatpak.sh"
# printf "====================\n"

# Create symlinks for dotfiles
echo "===================="
echo "Linking dotfiles"
printf "====================\n"

source ./link-dotfiles.sh
exec $SHELL -l

# Clone repos
# echo "===================="
# echo "Cloning repos"
# printf "====================\n"

# source shared/clone-repos.sh

echo "===================="
echo "Setup is done!"
printf "====================\n"
