#!/usr/bin/env bash

# -- $PATH

# function to remove duplicates in and echo $PATH
### no_dupes_path()
# Note: Inspired from https://www.linuxjournal.com/content/removing-duplicate-path-entries
no_dupes_path() {
    local no_dupes_path
    no_dupes_path=$(echo "${PATH}" | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')
    echo "${no_dupes_path}"
}

# function to echo $PATH one entry per line
### show_path()
# Note: Inspired from https://www.linuxjournal.com/content/removing-duplicate-path-entries
show_path() {
    awk -v RS=: '{print}' <<<"${PATH}"
}

# function to set $PATH with no dupes and echo one entry per line
### set_no_dupes_path()
# Note: Inspired from https://www.linuxjournal.com/content/removing-duplicate-path-entries
set_no_dupes_path() {
    PATH=$(no_dupes_path)
    export PATH
    show_path
}
