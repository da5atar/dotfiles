#!/bin/bash

# Expand the history size
export HISTFILESIZE=50000
export HISTSIZE=50000

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Save private binaries path
export USER_PATH="${HOME}/.local/bin"
