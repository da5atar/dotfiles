#!/usr/bin/env bash

# Save Homebrew's installed location.
export BREW_PREFIX
BREW_PREFIX=$(brew --prefix &>/dev/null)

# Set the default editor
export EDITOR=nano
alias edit='nano'
