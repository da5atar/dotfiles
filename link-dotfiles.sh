#!/bin/bash

unameOut="$(uname -s)"
case "${unameOut}" in
Linux*) MACHINE=Linux ;;
Darwin*) MACHINE=Mac ;;
CYGWIN*) MACHINE=Cygwin ;;
MINGW*) MACHINE=MinGw ;;
*) MACHINE="UNKNOWN:${unameOut}" ;;
esac

echo "Creating symlinks for dotfiles to $HOME"

# Symlink all dotfiles on Mac
if [[ $MACHINE == "Mac" ]]; then
  for f in dotfiles/\.[^.]*; do
    FILE="$(basename "$f")"
    ln -sf "$PWD/dotfiles/$FILE" "$HOME"
  done
fi

# .zshrc cannot be symlinked on WSL. ZSH will break if symlinked. Copy instead.
# This might change in WSL2
if [[ $MACHINE == "Linux" ]]; then
  for f in dotfiles/\.[^.]*; do
    FILE="$(basename $f)"
    if [[ $FILE == ".zshrc" ]]; then
      echo ".zshrc cannot be symlinked. Copying instead."
      cp -p "$PWD/dotfiles/.zshrc" "$HOME"
    else
      ln -sf "$PWD/dotfiles/$FILE" "$HOME"
    fi
  done
fi

# if .emacs.d exists, symlink it
if [[ -d $HOME/.emacs.d ]]; then
  ln -sf "$PWD/dotfiles/.emacs.d/init.el" "$HOME/.emacs.d"
fi

# Source .zshrc to update env
# Ignore the errors generated by this source.
# They only appear during this process. They work properly on new shell startup.
echo "Linked dotfiles. Please restart your shell. "
