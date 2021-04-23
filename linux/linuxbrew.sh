#!/usr/bin/env bash

# Install Homebrew (if not installed). See https://docs.brew.sh/Homebrew-on-Linux
echo "Installing Homebrew."

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH: 
test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Binaries
brew install thefuck
brew install z
brew install lynx
brew install howdoi

# Python:
brew install python3
brew install pyenv # python version management
brew install pyenv-virtualenvwrapper # python dependencies management wrapper

# Remove outdated versions from the cellar.
brew cleanup
