#!/usr/bin/env bash

# helper to add underscore to a string
_add_underscore() {
    str=$1
    echo "${str// /_}"
}

# continue
_proceed() {
    printf "Continue? [y/n] "
    read -r response
    case $response in
    y | Y) return 0 ;;
    n | N) return 1 ;;
    *) echo "Please answer yes or no." ;;
    esac
}

# See https://intoli.com/blog/exit-on-errors-in-bash-scripts/
### _exit_on_error
# Usage:
#   _exit_on_error $? !!
#   $? is the exit code of the last command
#   !! is the command that failed
_exit_on_error() {
    exit_code=$1
    last_command=${*:2}
    if [ "$exit_code" -ne 0 ]; then
        >&2 echo "\"${last_command}\" command exited with code ${exit_code}."
        exit "$exit_code"
    fi
}
