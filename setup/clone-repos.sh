#!/usr/bin/env bash
# shellcheck disable=SC2154,SC2312

# Change this value your custom location
# set CLONE_PATH
CLONE_PATH=${GITHUB_REPOS} || ${GITHUB_FOLDER} # set in .init

function clone() {
    # CD to folder where git repos are kept
    command cd "${CLONE_PATH}" || exit 1

    echo "Cloning repositories"
    # Cheat sheets
    git clone https://github.com/LeCoupa/awesome-cheatsheets.git
}

clone
unset clone
