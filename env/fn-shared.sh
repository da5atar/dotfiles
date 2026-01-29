#!/usr/bin/env bash

# --------------------------------------------------------------------
#   find_alias <alias_name>
#
#   Prints the definition(s) of <alias_name> as reported by a
#   “zsh -ixc” run.  Useful when you have many startup files and
#   want to know exactly where an alias comes from.
#
#   Example:
#       find_alias ls
# --------------------------------------------------------------------
find_alias() {
    local alias_name="${1:-}"
    if [[ -z "$alias_name" ]]; then
        echo "Usage: find_alias <alias_name>" >&2
        return 1
    fi

    # Run zsh in interactive mode, trace commands, and capture stderr.
    # The -x flag causes zsh to echo every command it executes, including
    # the alias definitions it reads from your startup files.
    zsh -ixc ":" 2>&1 | grep "alias '$alias_name"
}
