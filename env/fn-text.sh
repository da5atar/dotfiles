#!/usr/bin/env bash

#--- Text Editors

# Use the best version of pico installed
edit() {
    if [ "$(which pico)" ]; then
        pico "$@"
    elif [ "$(which nano)" ]; then
        nano -c "$@"
    elif [ "$(which vim)" ]; then
        vim "$@"
    elif [ "$(which vi)" ]; then
        vi "$@"
    else
        echo "No text editor found"
    fi
}

sedit() {
    if [ "$(which pico)" ]; then
        sudo pico -s "$@"
    elif [ "$(which nano)" ]; then
        sudo nano -c -s "$@"
    elif [ "$(which vim)" ]; then
        sudo vim -s "$@"
    elif [ "$(which vi)" ]; then
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
    echo -n "$var"
}

slugify() {
    echo "$1" | iconv -t ascii//TRANSLIT | sed -E 's/[^a-zA-Z0-9-]+/-/g' | sed -E 's/^-+|-+$//g' | tr '[:upper:]' '[:lower:]'
}

slug() {
    local arg="${1:-$PWD}"
    local trimmed_arg="${arg: -200}"
    local slug
    slug="$(slugify "$trimmed_arg")"
    echo "$slug"
}

prefix() {
    local prefix="${1%/*}"
    echo "$prefix"
}
