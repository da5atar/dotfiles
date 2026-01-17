#!/usr/bin/env bash

unameOut="$(uname -s)"
case "${unameOut}" in
Linux*) MACHINE=Linux ;;
Darwin*) MACHINE=Mac ;;
CYGWIN*) MACHINE=Cygwin ;;
MINGW*) MACHINE=MinGw ;;
*) MACHINE="UNKNOWN:${unameOut}" ;;
esac

echo "Creating symlinks for dotfiles to ${HOME}"

# Symlink all dotfiles
if [[ ${MACHINE} == "Mac" ]]; then
    for f in dotfiles/home/\.[^.]*; do
        FILE="$(basename "${f}")"
        ln -sf "${PWD}/dotfiles/home/${FILE}" "${HOME}"
    done
elif [[ ${MACHINE} == "Linux" ]]; then
    for f in dotfiles/home/\.[^.]*; do
        FILE="$(basename "${f}")"
        if [[ ${FILE} == ".zshrc" ]]; then
            echo ".zshrc cannot be symlinked. Copying instead."
            cp -p "${PWD}/dotfiles/home/.zshrc" "${HOME}"
        else
            ln -sf "${PWD}/dotfiles/home/${FILE}" "${HOME}"
        fi
    done
fi

echo "Linked dotfiles. Please restart your shell. "
