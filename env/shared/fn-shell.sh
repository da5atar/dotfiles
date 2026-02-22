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

# Normalize `open` across Linux, macOS, and Windows.
# This is needed to make the `o` function (see fn-dirs.sh) cross-platform.
if [[ ! "$(uname -s)" = 'Darwin' ]]; then
    alias open='xdg-open'
fi

# ---- PATH ----
# function to remove duplicates in and echo $PATH
# Note: Inspired from https://www.linuxjournal.com/content/removing-duplicate-path-entries

### no_dupes_path()
_no_dupes_path() {
    local no_dupes_path
    no_dupes_path=$(echo "$PATH" | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')
    echo "$no_dupes_path"
}

# function to echo $PATH one entry per line
### no_dupes_path()
show_path() {
    awk -v RS=: '{print}' <<<"$PATH"
}

# function to set $PATH with no dupes and echo one entry per line
### no_dupes_path()
set_no_dupes_path() {
    PATH=$(_no_dupes_path)
    export PATH
    show_path
}

# ---- FPATH ----

# function to echo $FPATH one entry per line
### no_dupes_fpath()
show_fpath() {
    awk -v RS=: '{print}' <<<"$FPATH"
}
