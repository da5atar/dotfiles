#!/bin/bash

# Change this value your custom location
# set CLONE_PATH
CLONE_PATH=$GITHUB_REPOS || $GITHUB_FOLDER # set in .init

function clone() {
  # CD to folder where git repos are kept
  cd "$CLONE_PATH" || exit 1

  echo "Cloning repositories"

  # Open source projects
  # python
  git clone https://github.com/vinta/awesome-python.git
  git clone https://github.com/trimstray/the-book-of-secret-knowledge.git

  #Microsoft
  git clone https://github.com/microsoft/Web-Dev-For-Beginners.git
  git clone https://github.com/microsoft/Data-Science-For-Beginners.git
  git clone https://github.com/microsoft/ML-For-Beginners.git

  # Blog

  # Products

  # Plugins
  # pyenv-install-latest
  git clone https://github.com/momo-lab/pyenv-install-latest.git "$(pyenv root)"/plugins/pyenv-install-latest
}

clone
unset clone
