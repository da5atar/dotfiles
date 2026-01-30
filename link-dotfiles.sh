#!/usr/bin/env sh

#=============================================================
# dotfiles/link-dotfiles.sh
#=============================================================
# This POSIX compliant script creates symlinks for dotfiles and
# recursively links all regular files under $HOME/.config.
# Git config files are copied only if they do not already exist.

# Resolve script directory
SCRIPT_DIR=$(command cd "$(dirname "$0")" && pwd)

echo "Creating symlinks for dotfiles in $HOME"

# Function to symlink files preserving relative path
link_files() {
    src_dir=$1
    dst_dir=$2
    # Ensure destination directory exists
    mkdir -p "$dst_dir"
    command find "$src_dir" -type f -print |
        while IFS= read -r file; do
            relative_path=${file#"$src_dir"/}
            # Skip git config files
            case "$relative_path" in
                git/*) continue;;
            esac
            target="$dst_dir/$relative_path"
            mkdir -p "$(dirname "$target")"
            command rm -f "$target"
            ln -s "$file" "$target"
        done
}

# 1. Symlink top‑level dotfiles
command find "$SCRIPT_DIR/dotfiles/home" -maxdepth 1 -type f -name '.*' -print |
    while IFS= read -r f; do
        FILE=$(basename "$f")
        command rm -f "$HOME/$FILE"
        ln -s "$f" "$HOME/$FILE"
    done

# 2. Recursively symlink files under ~/.config
link_files "$SCRIPT_DIR/dotfiles/.config" "$HOME/.config"

# 3. Copy git config files only if they do not already exist
command find "$SCRIPT_DIR/dotfiles/.config/git" -maxdepth 1 -type f -print |
    while IFS= read -r g; do
        FILE=$(basename "$g")
        TARGET="$HOME/.config/git/$FILE"
        mkdir -p "$HOME/.config/git"
        [ ! -e "$TARGET" ] && cp -p "$g" "$TARGET"
    done

echo "Linked dotfiles. Please restart your shell."
