#!/usr/bin/env bash
# shellcheck disable=SC2312

# Install Homebrew (if not installed). See https://docs.brew.sh/Homebrew-on-Linux
echo "Installing Homebrew."

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH:
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile

# Make sure we're using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew's installed location.
BREW_PREFIX=$(brew --prefix)
echo "Homebrew prefix is: ${BREW_PREFIX}"

# Binaries
brew install thefuck
brew install z
brew install lynx
brew install howdoi
brew install tldr
brew install xclip
brew install fd
brew install tokei
brew install dust
brew install exa

# Development
## pyenv build environment
brew install bzip2
brew install libffi
brew install libxml2
brew install libxmlsec1
brew install openssl
brew install readline
brew install sqlite
brew install xz
brew install zlib

# Python:
brew install python
brew install virtualenv
brew install virtualenvwrapper
brew install pyenv # python version management
brew install --HEAD pyenv-virtualenv
brew install --HEAD pyenv-virtualenvwrapper

# Remove outdated versions from the cellar.
brew cleanup
