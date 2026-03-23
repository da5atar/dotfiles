#!/usr/bin/env zsh
# ~/.zshrc
# computer: $HOSTNAME
# last_edit: 2026-03-18
# Resources:
#   ZSH cheat sheet: https://gist.github.com/da5atar/36f772d80d792a20b8543baef69c17c2
#   Setting PATH for ZSH on macOS: https://gist.github.com/da5atar/b87af08926d268c590f82fa8047c429e

## Overrides

# /etc/zshrc
export HISTSIZE=268435456
export SAVEHIST="$HISTSIZE"

setopt INC_APPEND_HISTORY

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
    autoupdate               # https://github.com/tamcore/autoupdate-oh-my-zsh-plugins
    autoswitch_virtualenv    # https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv
    fast-syntax-highlighting # https://github.com/zdharma-continuum/fast-syntax-highlighting
    ollama                   # https://github.com/Katrovsky/zsh-ollama-completion
    zsh-autocomplete         # https://github.com/marlonrichert/zsh-autocomplete
    zsh-autosuggestions      # https://github.com/zsh-users/zsh-autosuggestions
)

# ==========================================================
# 1. Additional ZSH Plugins and completions
# ==========================================================

# https://github.com/zsh-users/zsh-completions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

# Add local functions directory to fpath
fpath=(~/.local/share/zsh/site-functions $fpath)

# Initialize ZSH completion system
autoload -Uz compinit
# Oh-My-ZSH calls compinit when loading zsh

# ==========================================================
# 2. Load Oh My Zsh
# ==========================================================

source ${OHMYZSH}/oh-my-zsh.sh

# ==========================================================
# 3. Starship command prompt (https://github.com/starship/starship)
# ==========================================================

# Change default starship.toml file location with STARSHIP_CONFIG
export STARSHIP_CONFIG="${HOME}/.config/starship.toml"
eval "$(starship init zsh)"

# ==========================================================
# 4. Aliases & Exports
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

# Source all remaining files in the shared env folder
for file in "${PROJECT_ROOT}/env/shared/"*.sh; do
    # shellcheck source=/dev/null
    source "${file}"
done

# ==========================================================
# 5. Utilities
# ==========================================================

source "${HOME}/.utils.sh" # && echo "Zsh configuration loaded"

# --- End of file ---

# ==========================================================
# 6. New entries (auto-added)
# ==========================================================
