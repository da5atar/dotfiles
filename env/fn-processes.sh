#!/usr/bin/env bash

#--- Processes

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
# Usage: _exit_on_error $? !!
_exit_on_error() {
    exit_code=$1
    last_command=${*:2}
    if [ "$exit_code" -ne 0 ]; then
        echo >&2 "\"${last_command}\" command exited with code ${exit_code}."
        exit "$exit_code"
    fi
}

# Usage: deactivate running shell processes including virtual envs for graceful exit and reload
exit_shell() {
    # Deactivate any active virtual environment
    if command -v deactivate &>/dev/null; then
        deactivate &>/dev/null
    fi

    # Deactivate any active pyenv environment
    if command -v pyenv &>/dev/null; then
        pyenv deactivate &>/dev/null
    fi

    # Gracefully exit any running shell processes
    if jobs &>/dev/null; then
        kill -TERM "$(jobs -p)" &>/dev/null
    fi

    # Reload the shell
    exec "$SHELL" -l
}

# Find port in use (used to kill pid)
function findpid() {
    lsof -i tcp:"$*"
}

# USed to kill pid
function killpid() {
    kill -9 "$@"
}

# cpu_usage
function cpu_usage() {
    grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf("%.1f\n", usage)}'
}

alias cpu='cpu_usage'
