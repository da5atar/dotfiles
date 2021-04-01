#!/bin/bash

# Detect machine
unameOut="$(uname -s)"
case "${unameOut}" in
  Linux*)     MACHINE="Linux";;
  Darwin*)    MACHINE="Mac";;
  CYGWIN*)    MACHINE="Cygwin";;
  MINGW*)     MACHINE="MinGw";;
  *)          MACHINE="UNKNOWN:${unameOut}"
esac

echo "You apper to be using a $MACHINE computer"

echo "-----------------------"

echo "Installing Oh My Zsh!\n"

# Installs .oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  # Installs Oh my ZSH with Homebrew (Mac)
  if [[ $MACHINE == "Mac" ]]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  # Installs Oh my ZSH with Linux
  fi
  if [[ $MACHINE == "Linux" ]]; then  
    sudo apt install zsh -y
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
fi

# Assumes default ZSH installation
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# Installs plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Fix permissions
chmod 700 ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

