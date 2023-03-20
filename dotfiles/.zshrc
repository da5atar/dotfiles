#!/usr/bin/env bash

# Fig pre block. Keep at the top of this file.
if [[ "$MACHINE" == "Mac" ]]; then
    [[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Source shared .bash and .zshconfiguration (.rc)
source "$HOME/.init"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load.
ZSH_THEME="agnoster"
# ZSH_THEME="powerlevel10k/powerlevel10k" # https://github.com/romkatv/powerlevel10k

# Plugins
# plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(
    autojump
    git
    python
    z
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Fix Path to preferred order on MAC
if [[ "$MACHINE" == "Mac" ]]; then
    # Starship command prompt
    # Change default starship.toml file location with STARSHIP_CONFIG environment variable
    export STARSHIP_CONFIG="$HOME/.starship"
    eval "$(starship init zsh)"

    # Find brew utilities in /user/local/sbin
    export PATH="/usr/local/sbin:$PATH"

    # Ruby
    export PATH="/usr/local/lib/ruby/gems/3.0.0/bin:$PATH" # binaries installed by homebrew gem
    export PATH="/usr/local/opt/ruby/bin:$PATH"            # homebrew ruby

    # colorls
    source $(dirname $(gem which colorls))/tab_complete.sh

elif [[ "$MACHINE" == "Linux" ]] && [[ $(uname -m) == "x86_64" ]]; then
    # linuxbrew
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# userpath
export PATH="$USER_PATH:$PATH"

# default to base Python 3 installed with Homebrew
# python3_base

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ZSH shopt alternative
# Adapted from https://github.com/larz258/Zshopt
alias shopt='$PROJECT_ROOT/usr/bin/zshopt'

# Source utilities pyenv, anaconda, thefuck, z, fzf...
source "$HOME/.utils"

# Fig post block. Keep at the bottom of this file.
if [[ "$MACHINE" == "Mac" ]]; then
    [[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
fi

