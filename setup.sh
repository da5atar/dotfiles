#!/bin/bash
# shellcheck disable=SC1091

unameOut="$(uname -s)"
case "${unameOut}" in
Linux*) MACHINE=Linux ;;
Darwin*) MACHINE=Mac ;;
CYGWIN*) MACHINE=Cygwin ;;
MINGW*) MACHINE=MinGw ;;
*) MACHINE="UNKNOWN:${unameOut}" ;;
esac

if [[ "${MACHINE}" == "Linux" ]]; then
    source ./setup/linux.sh
elif [[ "${MACHINE}" == "Mac" ]]; then
    source ./setup/macos.sh
fi

# Set npm permissions and install npm binaries
echo "===================="
echo "Running npm.sh"
printf "====================\n"

source ./setup/npm.sh

echo "===================="
echo "Done running npm.sh"
printf "====================\n"

# install ZSH
echo "===================="
echo "Installing ZSH"
printf "====================\n"

source ./setup/install-zsh.sh

echo "===================="
echo "Done installing ZSH"
printf "====================\n"

# Create symlinks for dotfiles
echo "===================="
echo "Linking dotfiles"
printf "====================\n"

chmod +x ./link-dotfiles.sh
sh ./link-dotfiles.sh

echo "===================="
echo "Setup is done!"
printf "====================\n"
