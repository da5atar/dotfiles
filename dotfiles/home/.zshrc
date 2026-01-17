#!/usr/bin/env zsh
# ~/.zshrc
# computer: $HOSTNAME
# last_edit:

# Source init file
source "${HOME}/.init.sh"

# ==========================================================
# 0. Oh My Zsh Setup
# ==========================================================

# Path to your oh-my-zsh installation.
export OHMYZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="random"

# Oh My Zsh Plugins
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    docker
    docker-compose
    git
    macos
    z
)

# ==========================================================
# 1. Homebrew (https://docs.brew.sh/Shell-Completion)
# ==========================================================

if [[ "${MACHINE}" == "Mac" ]]; then
    # Homebrew
    eval $(/opt/homebrew/bin/brew shellenv)
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
elif [[ "${MACHINE}" == "Linux" ]] && [[ $(uname -m) == "x86_64" ]]; then
    # Linuxbrew
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# ==========================================================
# 2. ZSH Plugins and completions
# ==========================================================

# Zsh Completion (https://github.com/zsh-users/zsh-completions)
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

autoload -Uz compinit && compinit

# ==========================================================
# 3. Load Oh My Zsh
# ==========================================================

source ${OHMYZSH}/oh-my-zsh.sh

# ==========================================================
# 4. Starship command prompt (https://github.com/starship/starship)
# ==========================================================

export STARSHIP_CONFIG="${HOME}/.starship"
# Change default starship.toml file location with STARSHIP_CONFIG environment variable
eval "$(starship init zsh)"

# ==========================================================
# 5. Custom environment Variables & Exports
# ==========================================================

source ${HOME}/.env

# Pip
export PIP_REQUIRE_VIRTUALENV=true

# ==========================================================
# 6. Utilities
# ==========================================================

source "${HOME}/.utils.sh"

echo "Zsh configuration loaded"

# --- End of file ---

# ==========================================================
# 7. New entries (auto-added)
# ==========================================================
