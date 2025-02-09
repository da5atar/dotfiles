#!/usr/bin/env bash
# shellcheck disable=SC2154,SC2312

# Install Homebrew (if not installed)
echo "Installing Homebrew."

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH: (Only on Mac with ARM processors e.g M1)
# echo 'eval $(/opt/homebrew/bin/brew shellenv)' >> /Users/mass/.zprofile
# eval $(/opt/homebrew/bin/brew shellenv)

# Make sure we're using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install and setup Mongodb
# brew tap mongodb/brew
# brew install mongodb-community
# sudo mkdir -p /System/Volumes/Data/data/db
# sudo chown -R `id -un` /System/Volumes/Data/data/db

# Install GNU core utilities (those that come with macOS are outdated).
# Don't forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed` as gsed
brew install gnu-sed

# Install `wget` with IRI support.
brew install wget #--with-iri # FIX 1 option generates error

# Install useful binaries.
## system monitoring
brew install htop
brew install osx-cpu-temp # bpytop dependency

## Productivity
brew install ack
brew install autojump
brew install ncdu
brew install starship # Command prompt
brew install task
brew install thefuck
brew install tldr
brew install z
brew install fd
brew install tokei
brew install dust
brew install exa

# Dev

## pyenv build environment
brew install openssl
brew install readline
brew install sqlite3
brew install xz
brew install zlib

## Docker
brew install docker-completion
brew install docker-compose-completion
brew install docker-machine-completion

## Kubernetes
# brew install kubectl # Kubernetes CLI
# brew install minikube # runs a single-node Kubernetes cluster inside a VM

## Git
brew install git
brew install git-lfs
brew install github/gh/gh

## Git-toolbelt
brew install fzf
brew tap nvie/tap
brew install nvie/tap/git-toolbelt

brew install gmp
brew install grep
brew install jq
brew install howdoi
brew install node

# Python:
brew install python
# brew install anaconda
brew install pyenv # python version management
brew install virtualenv
brew install virtualenvwrapper

brew install ruby
brew install shellcheck
brew install ssh-copy-id
brew install tmux
brew install xonsh

# Utilities
# brew install ffmpeg
# brew install imagemagick --with-webp # FIX 2: option generates error
brew install p7zip
brew install pigz
brew install pv
brew install rsync
brew install rename
brew install tree
brew install vbindiff
brew install youtube-dl

# Installs Casks Fonts and preferred font
brew tap homebrew/cask-fonts
brew install font-fira-code --cask
# Nerd Fonts
brew install font-3270-nerd-font --cask
brew install font-hack-nerd-font --cask
brew install font-firacode-nerd-font --cask

## Apps I use
# brew install --cask alfred
# brew install --cask beamer
brew install --cask calibre
# brew install --cask dropbox
brew install --cask evernote
# brew install --cask homebrew/cask-versions/firefox-nightly # Nightly
# brew install --cask google-chrome #Chrome
# brew install --cask homebrew/cask-versions/google-chrome-canary # Chrome Canary
brew install --cask grammarly
# brew install --cask kap
# brew install --cask keycastr
# brew install --cask notion
brew install --cask obsidian
# brew install --cask sketch
# brew install --cask skitch
brew install --cask skype
# brew install --cask slack
brew install --cask spotify
# brew install --cask textexpander

# System utilities

# Dev casks
# brew install --cask androidtool
brew install --cask boostnote
# brew install --cask dash
brew install --cask docker # Docker desktop

# Terminal
brew install --cask hyper
brew install --cask iterm2
brew install --cask fig

# Python-Javascript
brew install --cask kite
# MongoDB
# brew install --cask mongodb-compass
# brew install --cask tower
# brew install --cask virtualbox

# Brew GUI
# brew install --cask cakebrew

# Useful Quick Look plugins for developers
# Seen on [mischah's](https://github.com/mischah/dotfiles/blob/my-custom-dotfiles/Caskfile) dotfiles
# Consult [this repo](https://github.com/sindresorhus/quick-look-plugins) for more info

brew install qlcolorcode qlstephen qlmarkdown quicklook-json qlimagesize apparency quicklookase qlvideo
brew install --cask suspicious-package

# Remove outdated versions from the cellar.
brew cleanup

# Security
brew install mailtrackerblocker
