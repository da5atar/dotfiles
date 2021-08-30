#!/bin/bash

# Save Homebrew’s installed location.
export BREW_PREFIX=$(brew --prefix)

# Current Dev Project folder
export CURRENT_DEV_PROJECT=$DEV_WORKSPACE"/Current_Project/"

# Python Projects
export PYTHON_PROJECT_DIR=$DEV_WORKSPACE"/Python/"
export PYTHON="$(which python)"
export PIP="$(which pip)"
export VIRTUALENV="$(which virtualenv)" 

# Set the default editor
export EDITOR=nano
alias nano='edit'

# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Directory for notes
export NOTES_DIRECTORY=${HOME}"/notes"