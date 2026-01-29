#!/usr/bin/env bash

echo "Creating symlinks for dotfiles to ${HOME}"

# Symlink all dotfiles
for f in dotfiles/home/\.[^.]*; do
    FILE="$(basename "${f}")"
    ln -sf "${PWD}/dotfiles/home/${FILE}" "${HOME}"
done

# Symlink config files
for c in dotfiles/.config/*; do
    if [ ! -d FILE="$(basename "${c}")" ]; then
        ln -sf "${PWD}/dotfiles/.config/${FILE}" "${HOME}/.config"
    fi
done

# Copy git config
for g in dotfiles/.config/git/*; do
    FILE="$(basename "${g}")"
    cp -n dotfiles/.config/git/"${FILE}" "${HOME}/.config/git"
done

echo "Linked dotfiles. Please restart your shell. "
