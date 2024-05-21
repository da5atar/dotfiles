#!/usr/bin/env bash

#--- Files

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
    local tmpFile="${*%/}.tar"
    tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1

    size=$(
        stat -f"%z" "${tmpFile}" 2>/dev/null # macOS `stat`
        stat -c"%s" "${tmpFile}" 2>/dev/null # GNU `stat`
    )

    local cmd=""
    if ((size < 52428800)) && hash zopfli 2>/dev/null; then
        # the .tar file is smaller than 50 MB and Zopfli is available; use it
        cmd="zopfli"
    else
        if hash pigz 2>/dev/null; then
            cmd="pigz"
        else
            cmd="gzip"
        fi
    fi

    echo "Compressing .tar ($((size / 1000)) kB) using \`${cmd}\`…"
    "${cmd}" -v "${tmpFile}" || return 1
    [ -f "${tmpFile}" ] && rm "${tmpFile}"

    zippedSize=$(
        stat -f"%z" "${tmpFile}.gz" 2>/dev/null # macOS `stat`
        stat -c"%s" "${tmpFile}.gz" 2>/dev/null # GNU `stat`
    )

    echo "${tmpFile}.gz ($((zippedSize / 1000)) kB) created successfully."
}

# Determine size of a file or total size of a directory
function fs() {
    if du -b /dev/null >/dev/null 2>&1; then
        local arg=-sbh
    else
        local arg=-sh
    fi
    if [[ -n "$*" ]]; then
        du $arg -- "$@"
    else
        du $arg .[^.]* ./*
    fi
}

# Create a data URL from a file
function dataurl() {
    local mimeType
    mimeType=$(file -b --mime-type "$1")
    if [[ $mimeType == text/* ]]; then
        mimeType="${mimeType};charset=utf-8"
    fi
    echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

# Extracts any archive(s) (if unp isn't installed)
extract() {
    for archive in "$@"; do
        if [ -f "$archive" ]; then
            case "$archive" in
            *.tar.bz2) tar xvjf "$archive" ;;
            *.tar.gz) tar xvzf "$archive" ;;
            *.bz2) bunzip2 "$archive" ;;
            *.rar) rar x "$archive" ;;
            *.gz) gunzip "$archive" ;;
            *.tar) tar xvf "$archive" ;;
            *.tbz2) tar xvjf "$archive" ;;
            *.tgz) tar xvzf "$archive" ;;
            *.zip) unzip "$archive" ;;
            *.Z) uncompress "$archive" ;;
            *.7z) 7z x "$archive" ;;
            *) echo "don't know how to extract '$archive'..." ;;
            esac
        else
            echo "'$archive' is not a valid file!"
        fi
    done
}

# Searches for text in all files in the current folder
ftext() {
    # -i case-insensitive
    # -I ignore binary files
    # -H causes filename to be printed
    # -r recursive search
    # -n causes line number to be printed
    # optional: -F treat search term as a literal, not a regular expression
    # optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
    grep -iIHrn --color=always "$1" . | less -r
}

## TODO 6: Refactor this function
# # Copy file with a progress bar
# cpp() {
#   set -e
#   strace -q -ewrite cp -- "${1}" "${2}" 2>&1 |
#     awk '{
# 	count += $NF
# 	if (count % 10 == 0) {
# 		percent = count / total_size * 100
# 		printf "%3d%% [", percent
# 		for (i=0;i<=percent;i++)
# 			printf "="
# 			printf ">"
# 			for (i=percent;i<100;i++)
# 				printf " "
# 				printf "]\r"
# 			}
# 		}
# 	END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
# }

# Compare original and gzipped file size
function gz() {
    local origsize
    local gzipsize
    local ratio
    origsize=$(wc -c <"$1")
    gzipsize=$(gzip -c "$1" | wc -c)
    ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l)
    printf "orig: %d bytes\n" "$origsize"
    printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio"
}

# Normalize `open` across Linux, macOS, and Windows.
# This is needed to make the `o` function (see below) cross-platform.
if [ ! "$(uname -s)" = 'Darwin' ]; then
    if grep -q Microsoft /proc/version; then
        # Ubuntu on Windows using the Linux subsystem
        alias open='explorer.exe'
    else
        alias open='xdg-open'
    fi
fi

# helper to add underscore to a string
add_underscore() {
    str=$1
    echo "${str// /_}"
}

# Function to find and delete files or folders
# Usage: delete
# -- Prompts user to enter 'file' or 'folder'
# -- Prompts user to enter the name of the file or folder to delete
# -- Prompts user to confirm deletion
# -- Moves the file or folder to the trash
# This function relies on the 'trash' command
delete() {
    echo "Do you want to delete a file or a folder? (file/folder)"
    read choice

    if [[ $choice != "file" ]] && [[ $choice != "folder" ]]; then
        echo "Invalid choice. Please enter 'file' or 'folder'."
        return
    fi

    echo "Enter the name of the $choice to delete:"
    read -r name

    echo "Searching for $choice named '$name' in all subdirectories..."

    # Find and list all matching files/folders recursively
    local items

    if [[ $choice == "folder" ]]; then
        items=$(find . -not -path '*/\.*' -depth -name "*$name*")
    elif [[ $choice == "file" ]]; then
        items=$(find . -not -path '*/\.*' -depth -type f -name "*$name*")
    fi

    if [[ -z $items ]]; then
        echo "No $choice found with name '$name'"
        return
    fi

    echo "Found the following $choice(s):"
    echo "$items"

    echo "Are you sure you want to move these to the trash? (yes/no)"
    read -r confirmation

    if [[ $confirmation == "yes" ]]; then
        echo "Moving to trash..."
        while IFS= read -r item; do
            trash "$item"
        done <<<"$items"
        echo "Operation completed."
    else
        echo "Operation cancelled."
    fi
}
