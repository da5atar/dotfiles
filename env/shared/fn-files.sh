#!/usr/bin/env bash

#--- Files

# Compression

# create_tar_gz()
#
# Compress a single file
# Create a .tar.gz archive, and `gzip` or `pigz` for compression
function create_tar_gz() {
    # Expect a single file argument
    if [[ -z "$1" ]]; then
        echo "Usage: create_tar_gz <file>" >&2
        return 1
    fi

    local file="${1%/}"
    if [ -d "$file" ]; then
        echo "Error: $file is a directory" >&2
        return 1
    fi

    local tmpfile="${file}.tar"
    tar -cvf "$tmpfile" --exclude=".DS_Store" "$file" || return 1

    local size
    if [[ $(uname) == Darwin ]]; then
        size=$(stat -f "%z" "$tmpfile" 2>/dev/null)
    else
        size=$(stat -c "%s" "$tmpfile" 2>/dev/null)
    fi

    local cmd=""
    if ((size < 1000000000)) && command -v gzip >/dev/null 2>&1; then
        cmd="gzip"
    elif ((size > 1000000000)) && command -v pigz >/dev/null 2>&1; then
        cmd="pigz"
    else
        echo "Error: No suitable compression tool found" >&2
        return 1
    fi

    echo "Compressing .tar $tmpfile ($((size / 1024))) KB using \`${cmd}\`..."
    "$cmd" -v "$tmpfile" || return 1
    [ -f "$tmpfile" ] && rm "$tmpfile"

    local zipped_size
    if [[ $(uname) == Darwin ]]; then
        zipped_size=$(stat -f "%z" "${tmpfile}.gz" 2>/dev/null)
    else
        zipped_size=$(stat -c "%s" "${tmpfile}.gz" 2>/dev/null)
    fi

    echo "${tmpfile}.gz - ($((zipped_size / 1024))) KB created successfully"
}
