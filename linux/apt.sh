#!/bin/bash

# ########
# Binaries
# ########

# Essential packages or very nice to have. The GTK
# version of Vim is to get +clipboard support, you'd still run terminal Vim.

sudo apt-get update && sudo apt-get install -y \
  vim-gtk \
  tmux \
  git \
  gpg \
  curl \
  rsync \
  unzip \
  htop \
  shellcheck \
  ripgrep \
  autojump \
  tree \
  xclip \
  youtube-dl \
  procps \
  file \
  gcc \
  snapd \
  flatpak \
  gnome-tweaks \
  barrier

# Python
# Install [Python build dependencies](https://github.com/pyenv/pyenv/wiki#suggested-build-environment) before attempting to install a new Python version with pyenv:

sudo apt install \
  make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
  libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev \
  libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y

# Install FZF (fuzzy finder on the terminal and used by a Vim plugin).
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

# Install ASDF (version manager which I use for non-Dockerized apps).
git clone https://github.com/asdf-vm/asdf.git ~/.asdf

# Install Node through ASDF.
# asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
# bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
# asdf install nodejs 12.17.0
# asdf global nodejs 12.17.0

# Install system dependencies for Ruby.
sudo apt-get install -y autoconf bison libssl-dev libyaml-dev \
  libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev

# Install Ruby through ASDF.
# asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
# asdf install ruby 2.7.1
# asdf global ruby 2.7.1

# Node
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install nodejs -y

# MongoDB for Ubuntu 18.04.
# Installation instructions: https://docs.mongodb.com/manual/administration/install-on-linux/
# wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
# echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
# sudo apt update
# sudo apt install -y mongodb-org

# Install Ansible.
# pip3 install --user ansible

# Install AWS CLI v2.
# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
#   && unzip awscliv2.zip && sudo ./aws/Install && rm awscliv2.zip

# # Install Terraform.
# curl "https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip" -o "terraform.zip" \
#   && unzip terraform.zip && chmod +x terraform \
#   && mv terraform ~/.local/bin && rm terraform.zip

# ubuntu-make
sudo add-apt-repository -y ppa:lyzardking/ubuntu-make
sudo apt-get -y update
sudo apt-get -y install ubuntu-make
