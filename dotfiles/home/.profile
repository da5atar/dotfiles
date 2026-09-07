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

  export BREW_HOME="${HOMEBREW_PREFIX}"
  export BREW_OPT="${HOMEBREW_PREFIX}/opt"
  export BREW_SHARE="${HOMEBREW_PREFIX}/share"

  # GNU tools PATH setup
  # coreutils, gawk, ged, gmake, gindent, gpatch, ggrep, gtar, gwhich
  for gnubin in "${BREW_OPT}"/*/libexec/gnubin; do
    export PATH="$gnubin:$PATH"
  done

  # Add GNU man pages
  for gnuman in "${BREW_OPT}"/*/libexec/gnuman; do
    if [ -d "$gnuman" ]; then
      export MANPATH="$gnuman:${MANPATH:-}"
    fi
  done

  # binutils
  # to have binutils first in PATH
  export PATH="${BREW_OPT}/binutils/bin:$PATH"
  # For compilers to find binutils
  export LDFLAGS="-L/${BREW_OPT}/binutils/lib"
  export CPPFLAGS="-I/${BREW_OPT}/binutils/include"

  # to have gnu `bison` first in path
  export PATH="${BREW_OPT}/bison/bin:$PATH"
  # for compilers to find `bison`
  export LDFLAGS="-L/${BREW_OPT}/bison/lib"

  # to have flex first in path
  export PATH="${BREW_OPT}/flex/bin:$PATH"
  # For compilers to find flex:
  export LDFLAGS="-L${BREW_OPT}/flex/lib"
  export CPPFLAGS="-I${BREW_OPT}/flex/include"

  # file-formula
  export PATH="${BREW_OPT}/file-formula/bin:$PATH"

  # Golang
  export GOROOT="${BREW_HOME}/go/libexec"
  export GOPATH=$HOME/go
  export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

  # m4
  export PATH="${BREW_OPT}/m4/bin:$PATH"

  # libressl
  export PATH="${BREW_OPT}/libressl/bin:$PATH"
  export LDFLAGS="-L${BREW_OPT}/libressl/lib"
  export CPPFLAGS="-I${BREW_OPT}/libressl/include"
  export PKG_CONFIG_PATH="${BREW_OPT}/libressl/lib/pkgconfig"

  # Ruby
  export PATH="${BREW_OPT}/ruby/bin:$PATH"
  export LDFLAGS="-L/${BREW_OPT}/ruby/lib"
  export CPPFLAGS="-I/${BREW_OPT}/ruby/include"
  # For pkgconf to find ruby
  export PKG_CONFIG_PATH="${BREW_OPT}/ruby/lib/pkgconfig"

  # SQLite3
  export PATH="${BREW_OPT}/sqlite/bin:$PATH"
  export LDFLAGS="-L/${BREW_OPT}/sqlite/lib"
  export CPPFLAGS="-I/${BREW_OPT}/sqlite/include"
  export PKG_CONFIG_PATH="${BREW_OPT}/sqlite/lib/pkgconfig"

  # unzip
  export PATH="${BREW_OPT}/unzip/bin:$PATH"

fi

### find binaries in .local/bin
export PATH="${HOME}/.local/bin:$PATH"

### Python

# Avoid global installs with pip
export PIP_REQUIRE_VIRTUALENV=true

### Neovide
export NVIM_APPNAME=nvim_astro
