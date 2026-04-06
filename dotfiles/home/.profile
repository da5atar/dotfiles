#!/usr/bin/env bash

# Environment variables

## Platform
unameOut="$(uname -s)"
case "${unameOut}" in
Linux*) MACHINE=Linux ;;
Darwin*) MACHINE=Mac ;;
CYGWIN*) MACHINE=Cygwin ;;
MINGW*) MACHINE=MinGw ;;
*) MACHINE="UNKNOWN:${unameOut}" ;;
esac
export MACHINE

## PATH Setup

if [[ "${MACHINE}" == "Mac" ]]; then
  ### Homebrew

  # Shell completion (https://docs.brew.sh/Shell-Completion)
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # coreutils
  export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

  # Ruby
  export PATH="/opt/homebrew/opt/ruby/bin:$PATH" # To have Homebrew Ruby first in PATH
  # For compilers to find Ruby
  export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
  # For pkgconf to find ruby
  export PKG_CONFIG_PATH="/opt/homebrew/opt/ruby/lib/pkgconfig"

  # SQLite3
  export PATH="/opt/homebrew/opt/sqlite/bin:$PATH" # to have homebrew sqlite first in PATH
  export LDFLAGS="-L/opt/homebrew/opt/sqlite/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/sqlite/include"
  export PKG_CONFIG_PATH="/opt/homebrew/opt/sqlite/lib/pkgconfig" # For pkg-config to find sqlite

  # Golang
  export GOROOT=$(brew --prefix go)/libexec
  export GOPATH=$HOME/go
  export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
fi

### find binaries in .local/bin
export PATH="${HOME}/.local/bin:$PATH"

### Python

# Avoid global installs with pip
export PIP_REQUIRE_VIRTUALENV=true

# Pyenv
# https://github.com/pyenv/pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - "${SHELL}")"
# https://github.com/pyenv/pyenv-virtualenv
eval "$(pyenv virtualenv-init -)"
