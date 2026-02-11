#!/usr/bin/env bash

#--- Files

# Compression

# create_tar_gz()
#
# Compress a single file
# Create a .tar.gz archive, and `gzip` or `pigz` for compression
#
# Arguments:
#   $1: file to compress
#
# Returns:
#   0 if successful, non-zero on error
#
# Usage:
#   create_tar_gz <file>
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

# Extraction

# extract()
# Extracts an archive to the current directory.
#
# Arguments:
#   $1 - The tarball to extract
#
# Returns:
#   0 if the tarball was extracted successfully, 1 otherwise
#
# Usage:
#   extract <archive>
function extract() {
    for archive in "$@"; do
        if [[ -f "$archive" ]]; then
            local extension="${archive##*.}"
            case "$extension" in
            tar.bz2)
                tar -xvjf "$archive"
                ;;
            tar.gz)
                tar -xvzf "$archive"
                ;;
            tar.xz)
                tar -xvJf "$archive"
                ;;
            tar.Z)
                tar -xvZf "$archive"
                ;;
            tar)
                tar -xvf "$archive"
                ;;
            gz)
                gunzip -f "$archive"
                ;;
            bz2)
                bunzip2 -f "$archive"
                ;;
            zip)
                unzip -o "$archive"
                ;;
            Z)
                uncompress -f "$archive"
                ;;
            *)
                echo "don't know how to extract '$archive'..."
                ;;
            esac
        else
            echo "'$archive' is not a valid file!"
        fi
    done
}

# create_data_url()
# create a data URL from a file
# A data URL is a URI scheme that allows data to be directly encoded within URLs or resource identifiers without the need for separate external reference.
# The data URL scheme is defined in RFC 2397.
#
# Arguments:
#   $1: The file to create a data URL from.
#
# Returns:
#   The data URL.
#
# Usage:
#   create_data_url </path/to/your/file>
function create_data_url() {
    # Get the MIME type of the file
    local mimeType=$(file -b --mime-type "$1")

    # If the MIME type is text, specify charset as UTF-8
    if [[ $mimeType == text/* ]]; then
        mimeType="${mimeType};charset=utf-8"
    fi

    # Create and return the data URL
    echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}
