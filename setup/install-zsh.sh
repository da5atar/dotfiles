#!/usr/bin/env bash

# Detect machine
unameOut="$(uname -s)"
case "${unameOut}" in
Linux*) MACHINE="Linux" ;;
Darwin*) MACHINE="Mac" ;;
CYGWIN*) MACHINE="Cygwin" ;;
MINGW*) MACHINE="MinGw" ;;
*) MACHINE="UNKNOWN:${unameOut}" ;;
esac

echo "You appear to be using a $MACHINE computer"

echo "-----------------------"

printf "Installing Oh My Zsh!\n"

# Installs .oh-my-zsh
if [[ $MACHINE == "Linux" ]]; then
  sudo apt install zsh -y
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
elif [[ $MACHINE == "Mac" ]] && [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

printf "Done installing Oh My Zsh!\n"

echo "-----------------------"

printf "Installing ZSH Plugins\n"

# Installs ZSH plugins

# ZSH Auto Suggestions
git clone https://github.com/zsh-users/zsh-autosuggestions.git \
  "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions

# ZSH Completions
git clone https://github.com/zsh-users/zsh-completions.git \
  "${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}"/plugins/zsh-completions

# ZSH Autoswitch Virtualenv
git clone "https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv.git" \
  "${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}"/plugins/autoswitch_virtualenv

# ZSH Fast Syntax Highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/plugins/fast-syntax-highlighting

# ZSH Ollama Completions
git clone https://github.com/Katrovsky/zsh-ollama-completion.git \
  "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/ollama

# autoupdate-zsh-plugin
mkdir -p "${ZSH_CUSTOM}"/plugins/autoupdate
git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins "${ZSH_CUSTOM}"/plugins/autoupdate

# fzf-tab
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab

printf "Done installing ZSH Plugins!\n"

# source .zshrc
source ~/.zshrc
