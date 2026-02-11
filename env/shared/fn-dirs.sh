#!/usr/bin/env bash
# shellcheck disable=SC2310,SC2312

#--- Directories

# Normalize `open` across Linux and macOS.
# This is needed to make the `o` function (see below) cross-platform.
if [ ! "$(uname -s)" = 'Darwin' ]; then
    if [ -x "$(command -v xdg-open)" ]; then
        alias open='xdg-open'
    fi
fi

# `o` with no arguments opens the current directory, otherwise opens the given
# location
function o() {
    if [[ $# -eq 0 ]]; then
        open .
    else
        open "$@"
    fi
}

# Copy and go to the directory
cpg() {
    if [[ -d "$2" ]]; then
        cp "$1" "$2" && cd "$2"
    else
        cp "$1" "$2"
    fi
}

# Move and go to the directory
mvg() {
    if [[ -d "$2" ]]; then
        mv "$1" "$2" && cd "$2"
    else
        mv "$1" "$2"
    fi
}

# Create and go to the directory
mkdirg() {
    mkdir -p "$1"
    cd "$1"
}

# Create a new directory and enter it
function mkd() {
    mkdir -p "$@" && cd "${_}"
}

# Go to the specified directory if it exists or creates it and enters it
function goto_dir() {
    if [[ -d "$1" ]]; then
        cd "$1"
    else
        echo "Directory $1 does not exist. Creating..."
        mkdirg "$1" || return 1
    fi
}

# Goes up a specified number of directories  (i.e. up 4)
up() {
    local d=""
    limit=$1
    for ((i = 1; i <= limit; i++)); do
        d=${d}/..
    done
    d=$(echo "${d}" | sed 's/^\///')
    if [[ -z "${d}" ]]; then
        d=..
    fi
    cd "${d}"
}

# Get current directory name without full path
### here()
here() {
    local here=${PWD##*/}
    printf '%q\n' "${here}"
}

# Automatically do an ls after each cd
cd() {
    if [[ -n "$1" ]]; then
        builtin cd "$@" && printf "Listing Directory:\n" && ls
    else
        echo "No directory specified - defaulting to ${HOME}"
        builtin cd ~ && printf "Listing Directory:\n" && ls
    fi
}

# Returns the last 2 fields of the working directory
pwdtail() {
    pwd | awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
}

# Function to sync two folders using rsync
### dsync()
# --delete flag tells rsync to delete files in dest_dir when they no longer exist in src_dir
# --filter=':- .gitignore' tells rsync to exclude the files that are listed in the .gitignore file in each directory
# --chmod='F-w' portion tells rsync that the copied files (but not directories) should have their write permissions removed
# it prevents us from accidentally going into the dest_dir instead of the authoritative src_dir and making edits.
# The function takes 2 parameters:
# $src_dir gets the first given argument
# $dest_dir gets the second
# inspired from Adam Shaw (https://arshaw.com/exclude-node-modules-dropbox-google-drive)
dsync() {
    #!/usr/bin/env bash
    set -e # always immediately exit upon error

    # directory config. ending slashes are important!
    src_dir=$1
    dest_dir=$2

    # run the sync
    rsync -ar --delete \
        --filter=':- .gitignore' \
        --exclude='node_modules' \
        --exclude='.git' \
        --exclude='.DS_Store' \
        --chmod='F-w' \
        "${src_dir}" "${dest_dir}"
}

# Works on hidden files, directories and regular files
### isEmpty()
# This function takes one parameter:
# $1 is the directory to check or defaults to current directory
# -- Echoes if the directory has files or not
function isEmpty() {
    dir="${1:-"${PWD}"}" # defaults to current dir if no argument

    if [[ -n "$(ls -A "${dir}")" ]]; then
        echo "The directory ${dir} contains files:"
        ls -A "${dir}"
        echo "-----"
        return 1
    else
        echo "The directory is empty (or doesn't exist on this path)"
        return 0
    fi
}

# Clear directory content if directory is not empty
### clean_dir()
# This function takes one parameter:
# $1 is the directory to clear or defaults to current directory
# -- Calls isEmpty to check if directory contains files
clear_dir() {
    if ! (isEmpty "${@:-"${PWD}"}"); then
        ls -la
        # Remove all files including hidden .files
        rm -vrf "${PWD:?}/"* # this form ensures it never expand to root folder
        rm -vrf "${PWD:?}/".*
    fi
}
