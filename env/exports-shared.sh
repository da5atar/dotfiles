#!/usr/bin/env bash

# Save Homebrew's installed location.
export BREW_PREFIX
BREW_PREFIX=$(brew --prefix &>/dev/null)

# Colors
export BLACK="\033[0;30m"
export BLUE="\033[0;34m"
export BROWN="\033[0;33m"
export CYAN="\033[0;36m"
export DARKGRAY="\033[1;30m"
export GREEN="\033[0;32m"
export LIGHTBLUE="\033[1;34m"
export LIGHTCYAN="\033[1;36m"
export LIGHTGRAY="\033[0;37m"
export LIGHTGREEN="\033[1;32m"
export LIGHTMAGENTA="\033[1;35m"
export LIGHTRED="\033[1;31m"
export MAGENTA="\033[0;35m"
export NOCOLOR="\033[0m"
export RED="\033[0;31m"
export WHITE="\033[1;37m"
export YELLOW="\033[1;33m"

# Set the default editor
export EDITOR=nano
alias edit='nano'
