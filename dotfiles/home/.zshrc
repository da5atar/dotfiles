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

# Plugins
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    # Oh My Zsh Plugins
    docker
    docker-compose
    git
    git-prompt
    macos
    npm
    starship
    z
    # $ZSH_CUSTOM
    autoswitch_virtualenv    # https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv
    fast-syntax-highlighting # https://github.com/zdharma-continuum/fast-syntax-highlighting
    zsh-autocomplete         # https://github.com/marlonrichert/zsh-autocomplete
    zsh-autosuggestions      # https://github.com/zsh-users/zsh-autosuggestions
)

# ==========================================================
# 1. Homebrew (https://docs.brew.sh/Shell-Completion)
# ==========================================================

if [[ "${MACHINE}" == "Mac" ]]; then
    # Homebrew
    eval $(/opt/homebrew/bin/brew shellenv)
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
fi

# ==========================================================
# 2. Additional ZSH Plugins and completions
# ==========================================================

# https://github.com/zsh-users/zsh-completions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

autoload -U compinit && compinit

# ==========================================================
# 3. Load Oh My Zsh
# ==========================================================

source ${OHMYZSH}/oh-my-zsh.sh

# ==========================================================
# 4. Starship command prompt (https://github.com/starship/starship)
# ==========================================================

export STARSHIP_CONFIG="${HOME}/.config/starship.toml"
# Change default starship.toml file location with STARSHIP_CONFIG environment variable
eval "$(starship init zsh)"

# ==========================================================
# 5. Aliases & Exports
# ==========================================================

# Source aliases and exports
# For a full list of active aliases, run `alias`.
if [[ "${MACHINE}" == "Linux" ]]; then
    # shellcheck source=/dev/null
    source "${PROJECT_ROOT}/env/linux/exports-linux.sh"
    # shellcheck source=/dev/null
    source "${PROJECT_ROOT}/env/linux/aliases-linux.sh"
elif [[ "${MACHINE}" == "Mac" ]]; then
    # shellcheck source=/dev/null
    source "${PROJECT_ROOT}/env/macos/exports-mac.sh"
    # shellcheck source=/dev/null
    source "${PROJECT_ROOT}/env/macos/aliases-mac.sh"
fi

# Source all remaining files in the env folder
for file in "${PROJECT_ROOT}/env/shared/"*.sh; do
    # shellcheck source=/dev/null
    source "${file}"
done

# ==========================================================
# 6. Utilities
# ==========================================================

source "${HOME}/.utils.sh"

echo "Zsh configuration loaded"

# --- End of file ---

# ==========================================================
# 7. New entries (auto-added)
# ==========================================================
