#!/bin/bash
# shellcheck disable=SC2312

# ########
# Binaries
# ########

# Essential packages or very nice to have. The GTK
# version of Vim is to get +clipboard support, you'd still run terminal Vim.

sudo apt-get update && sudo apt-get install -y \
  autojump \
  curl \
  file \
  flatpak \
  gcc \
  git \
  gnome-tweaks \
  gpg \
  htop \
  procps \
  ripgrep \
  rsync \
  shellcheck \
  snapd \
  tmux \
  tree \
  unzip \
  vim-gtk \
  wget \
  xclip
# barrier \
# youtube-dl

# ############
# Dependencies
# ############

# System dependencies for Python, Ruby etc. in alphabetical order.
sudo apt-get install -y \
  autoconf \
  bison \
  build-essential \
  libbz2-dev \
  libdb-dev \
  libffi-dev \
  libgdbm6 \
  liblzma-dev \
  libncurses5-dev \
  libncursesw5-dev \
  libreadline-dev \
  libsqlite3-dev \
  libssl-dev \
  libreadline-dev \
  libreadline6-dev \
  libsqlite3-dev \
  libxml2-dev \
  libxmlsec1-dev \
  libyaml-dev \
  libbz2-dev \
  liblzma-dev \
  llvm \
  make \
  python3-dev \
  python3-openssl \
  python3-pip \
  python3-setuptools \
  tk-dev \
  wget \
  xz-utils \
  zlib1g-dev

sudo unminimize

# ###########
# Development
# ###########

# Python
curl https://pyenv.run | bash

# Postgres
sudo apt-get install -y postgresql postgresql-contrib

# Install Node.js 18 (LTS) and NPM.
# Maintened until April 2025 (https://nodejs.org/en/about/releases/)
curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# MongoDB
# sudo apt-get install -y mongodb

# ubuntu-make
sudo add-apt-repository -y ppa:lyzardking/ubuntu-make
sudo apt-get -y update
sudo apt-get -y install ubuntu-make

# #########
# Utilities
# #########

# Install FZF (fuzzy finder on the terminal and used by a Vim plugin).
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

# lsd (ls replacement)
sudo apt install lsd -y

# cleanup
sudo apt-get autoremove -y
sudo apt-get clean -y
