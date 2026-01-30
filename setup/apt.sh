#!/usr/bin/env bash
# shellcheck disable=SC2312

# ---- Binaries ----

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
    jq \
    procps \
    ripgrep \
    rsync \
    shellcheck \
    snapd \
    tmux \
    tree \
    unzip \
    vim-gtk \
    wget

# ---- Dependencies ----

# System dependencies for Python, Ruby etc. .
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
    xz-utils \
    zlib1g-dev

sudo unminimize

# ---- Development ----

# Python
curl -LsSf https://astral.sh/uv/install.sh | sh

# Postgres
sudo apt-get install -y postgresql postgresql-contrib

# Install Node.js 24 (LTS) and NPM.
# Maintened until April 2028 (https://nodejs.org/en/about/releases/)
curl -sL https://deb.nodesource.com/setup_24.x | sudo -E bash -
sudo apt-get install -y nodejs

# MongoDB
# sudo apt-get install -y mongodb

# ---- Utilities ----

# Install FZF (fuzzy finder on the terminal and used by a Vim plugin).
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

# lsd (ls replacement)
sudo apt install lsd -y

# cleanup
sudo apt-get autoremove -y
sudo apt-get clean -y
