#!/bin/bash
# shellcheck disable=SC1090,SC2312

# Detect machine
unameOut="$(uname -s)"
case "${unameOut}" in
Linux*) MACHINE="Linux" ;;
Darwin*) MACHINE="Mac" ;;
CYGWIN*) MACHINE="Cygwin" ;;
MINGW*) MACHINE="MinGw" ;;
*) MACHINE="UNKNOWN:${unameOut}" ;;
esac

echo "You appear to be using a ${MACHINE} computer"

echo "-----------------------"

printf "Installing Oh My Zsh!\n"

# Installs .oh-my-zsh
if [[ ! -d "${HOME}/.oh-my-zsh" ]]; then
  # Installs Oh my ZSH with Homebrew (Mac)
  if [[ ${MACHINE} == "Mac" ]]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  # Installs Oh my ZSH with Linux
  fi
  if [[ ${MACHINE} == "Linux" ]]; then
    sudo apt install zsh -y
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
fi

echo "-----------------------"

# Installs plugins
printf "Done installing Oh My Zsh!\n"

source shared/install-zsh-plugins.sh

source ~/.zshrc
