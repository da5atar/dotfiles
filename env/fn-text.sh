#!/usr/bin/env bash
# shellcheck disable=SC2230,SC2312

#--- Text Editors

# Use the best version of pico installed
edit() {
    if [[ -n "$(which pico)" ]]; then
        pico "$@"
    elif [[ -n "$(which nano)" ]]; then
        nano -c "$@"
    elif [[ -n "$(which vim)" ]]; then
        vim "$@"
    elif [[ -n "$(which vi)" ]]; then
        vi "$@"
    else
        echo "No text editor found"
    fi
}

sedit() {
    if [[ -n "$(which pico)" ]]; then
        sudo pico -s "$@"
    elif [[ -n "$(which nano)" ]]; then
        sudo nano -c -s "$@"
    elif [[ -n "$(which vim)" ]]; then
        sudo vim -s "$@"
    elif [[ -n "$(which vi)" ]]; then
        sudo vi -s "$@"
    else
        echo "No text editor found"
    fi
}

# Trim leading and trailing spaces (for scripts)
trim() {
    local var=$*
    var="${var#"${var%%[![:space:]]*}"}" # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}" # remove trailing whitespace characters
    echo -n "${var}"
}

slugify() {
    echo "$1" | iconv -t ascii//TRANSLIT | sed -E 's/[^a-zA-Z0-9-]+/-/g' | sed -E 's/^-+|-+$//g' | tr '[:upper:]' '[:lower:]'
}

slug() {
    local arg="${1:-${PWD}}"
    local trimmed_arg="${arg: -200}"
    local slug
    slug="$(slugify "${trimmed_arg}")"
    echo "${slug}"
}

prefix() {
    local prefix="${1%/*}"
    echo "${prefix}"
}
