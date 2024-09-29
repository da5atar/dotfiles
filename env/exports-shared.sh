#!/bin/bash

# Save Homebrew's installed location.
export BREW_PREFIX
BREW_PREFIX=$(brew --prefix &>/dev/null)

# Current Dev Project folder
export CURRENT_DEV_PROJECT=$DEV_WORKSPACE"/Current_Project"

# Python Projects
export PYTHON_PROJECT_DIR=$DEV_WORKSPACE"/Python"
SYS_PYTHON=$(which python3)
export SYS_PYTHON
export PYTHON
export PYTHON2
export PYTHON3
export PYTHON3_LATEST
export PIP="$PYTHON -m pip"
export PIP2
export PIP3
export VIRTUALENV

# Pyenv https://github.com/pyenv/pyenv
unset PYENV_VERSION
export PYENV_VERSION_2="2.7.18"
export PYENV_VERSION_3="3.12.3"
export PYENV_VERSION_3_LATEST
export VENV_FOLDER
VENV_FOLDER=$DEV_WORKSPACE"/Dependencies/Python/Virtualenvs"
export VIRTUALENV_HOME=$VENV_FOLDER

# Virtualenvwrapper https://virtualenvwrapper.readthedocs.io/en/latest/
export VIRTUALENVWRAPPER_SCRIPT_PREFIX
export PROJECT_HOME="$DEV_WORKSPACE/Projects/Python/$HOSTNAME"

# Autoswitch https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv
export AUTOSWITCH_DEFAULT_PYTHON="$PYENV_PYTHON"
export AUTOSWITCH_VIRTUAL_ENV_DIR="$VENV_FOLDER/$HOSTNAME/Autoswitch"
export AUTOSWITCH_FILE=".autoswitch"
export AUTOSWITCH_DEFAULTENV="Tools-exys"

# Set the default editor
export EDITOR=nano

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
    export NOTES_DIRECTORY="$DROPBOX_FOLDER/75_99_Archives/95_99_Notes/95_Daily/Shell_Notes"
else
    export NOTES_DIRECTORY=${HOME}"/notes"
fi

# Starship
export STARSHIP_CONFIG_PATH="$HOME/.starship.toml"
export STARSHIP_CONFIG="$HOME/.starship.toml"

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
