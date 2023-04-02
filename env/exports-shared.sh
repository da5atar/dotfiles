#!/bin/bash

# Save Homebrew's installed location.
export BREW_PREFIX
BREW_PREFIX=$(brew --prefix &>/dev/null)

# Current Dev Project folder
export CURRENT_DEV_PROJECT=$DEV_WORKSPACE"/Current_Project"

# Python Projects
export PYTHON_PROJECT_DIR=$DEV_WORKSPACE"/Python/Projects"
export SYS_PYTHON
SYS_PYTHON=$(which python3)
export PYTHON="$SYS_PYTHON"
export PYTHON2
export PYTHON3
export PYTHON3_LATEST
export PIP="$PYTHON -m pip"
export PIP2
export PIP3
export VIRTUALENV
export AUTOSWITCH_DEFAULT_PYTHON="$PYTHON"

# Pyenv
unset PYENV_VERSION
export PYENV_VERSION_2=2.7.18
export PYENV_VERSION_3=3.9.7
export PYENV_VERSION_3_LATEST
export VENV_FOLDER
VENV_FOLDER=$DEV_WORKSPACE"/Python/Virtualenvs"
export AUTOSWITCH_VIRTUAL_ENV_DIR="$VENV_FOLDER/Autoswitch"
export VIRTUALENV_HOME=$VENV_FOLDER
export VIRTUALENVWRAPPER_SCRIPT_PREFIX

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
# text notes
if [[ "$MACHINE" == "Mac" || "$MACHINE" == "Linux" ]]; then
    export NOTES_DIRECTORY="$DROPBOX_FOLDER/Areas/Personal/Notes"
else
    export NOTES_DIRECTORY=${HOME}"/notes"
fi

# Starship
export STARSHIP_CONFIG_PATH="$HOME/.starship.toml"
export STARSHIP_CONFIG="$HOME/.starship.toml"

# Colors
export GREEN="\033[0;32m"
export NOCOLOR="\033[0m"

