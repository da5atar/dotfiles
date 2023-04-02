#!/usr/bin/env bash

#--- Files

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
    local tmpFile="${@%/}.tar"
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
    if [[ -n "$@" ]]; then
        du $arg -- "$@"
    else
        du $arg .[^.]* ./*
    fi
}

# Create a data URL from a file
function dataurl() {
    local mimeType=$(file -b --mime-type "$1")
    if [[ $mimeType == text/* ]]; then
        mimeType="${mimeType};charset=utf-8"
    fi
    echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

# Extracts any archive(s) (if unp isn't installed)
extract() {
    for archive in $*; do
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
    local origsize=$(wc -c <"$1")
    local gzipsize=$(gzip -c "$1" | wc -c)
    local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l)
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

#--- Processes

# continue
_proceed () {
    printf "Continue? [y/n] "
    read -r response
    case $response in
        y | Y) return 0;;
        n | N) return 1;;
        * ) echo "Please answer yes or no.";;
    esac
}

# See https://intoli.com/blog/exit-on-errors-in-bash-scripts/
### _exit_on_error
# Usage: _exit_on_error $? !!
_exit_on_error() {
    exit_code=$1
    last_command=${@:2}
    if [ $exit_code -ne 0 ]; then
        >&2 echo "\"${last_command}\" command exited with code ${exit_code}."
        exit "$exit_code"
    fi
}

# Usage: deactivate running shell processes including virtual envs for graceful exit and reload
exit_shell() {
  # Deactivate any active virtual environment
  if command -v deactivate &> /dev/null; then
    deactivate &> /dev/null
  fi

  # Deactivate any active pyenv environment
  if command -v pyenv &> /dev/null; then
    pyenv deactivate &> /dev/null
  fi

  # Gracefully exit any running shell processes
  if jobs &> /dev/null; then
    kill -TERM $(jobs -p) &> /dev/null
  fi

  # Reload the shell
#   exec "$SHELL"
}

# Find port in use (used to kill pid)
function findpid() {
    lsof -i tcp:"$*"
}

# USed to kill pid
function killpid() {
    kill -9 "$@"
}


#--- Media

# Function to downloads a .mp3 file from YouTube
# Requires youtube-dl
function dlmp3() {
    song="$1"
    youtube-dl -x --extract-audio --audio-format mp3 "ytsearch:$song"
}
# Function to downloads a .mp4 file from YouTube
function dlmp4() {
    video="$1"
    youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' "ytsearch:$video"
}

# Function to echo the current time
### timestamp()
# Just echoes the formatted time
timestamp() {
    date "+%Y-%m-%d_%H:%M:%S"
}

#--- Python

## Save python version output in a variable
pyversion() {
    _set_python_alias
    _pyversion=$($PYTHON --version 2>&1) # needs redirect because defaults to stderr
    echo "$_pyversion"
}

## Returns Python version with underscore
_add_underscore_pyversion() {
    pyv=$(pyversion)
    add_underscore "$pyv"
}

### Print python info
py_info() {
    local GREEN="\033[0;32m"
    local NOCOLOR='\033[0m'

    echo "${GREEN}Python Info: ${NOCOLOR}"
    printf "=====\n"
    echo "${GREEN}Using: ${NOCOLOR}"
    which "$PYTHON"
    echo "${GREEN}Version: ${NOCOLOR}"
    $PYTHON -V
    echo "${GREEN}with: ${NOCOLOR}"
    $VIRTUALENV --version
    echo "${GREEN}Virtualenvwrapper Info: ${NOCOLOR}"
    $PYTHON -m pip show virtualenvwrapper | grep -e Version -e Location
    echo "${GREEN}and: ${NOCOLOR}"
    $PYTHON -m pip --version
    echo "${GREEN}type 'pip list' for a list of installed packages${NOCOLOR}"
    printf "=====\n"
}

### function to ensure python command is available
_set_python_alias() {
    # Set python alias if python command is not found
    if ! python --version &>/dev/null; then
        if python3 --version &>/dev/null; then
            export PYTHON=python3
            alias python='$PYTHON'
        fi
    fi
}

## Virtualenv
_is_virtualenv() {
    if [ "$($PYTHON -m virtualenv --version)" ]; then
        echo "Virtualenv is installed for $($PYTHON -V 2>&1 | head -n 1)"
        # Save which virtualenv
        VIRTUALENV=$(which virtualenv)
        return 0
    else
        echo "Virtualenv is not installed for this Python version"
        return 1
    fi
}

_virtualenv_info() {
    local GREEN="\033[0;32m"
    local NOCOLOR='\033[0m'
    echo "${GREEN}Virtualenv Info: ${NOCOLOR}"
    echo "${GREEN}Using: ${NOCOLOR} $(which virtualenv)"
    $PYTHON -m pip show virtualenv | grep -e Version -e Location
}

## Virtualenvwrapper
_is_virtualenvwrapper() {
    if [ "$(which virtualenvwrapper.sh)" ]; then
        echo "Virtualenvwrapper is installed for $($PYTHON -V 2>&1 | head -n 1)"
        # Save which virtualenv
        VIRTUALENVWRAPPER=$(which virtualenvwrapper.sh)
        return 0
    else
        echo "Virtualenvwrapper is not installed for this Python version"
        return 1
    fi
}

_virtualenvwrapper_info() {
    local GREEN="\033[0;32m"
    local NOCOLOR='\033[0m'
    echo "${GREEN}Virtualenvwrapper Info: ${NOCOLOR}"
    $PYTHON -m pip show virtualenvwrapper | grep -e Version -e Location
}

### virtualenvwrapper initializer
init_virtualenvwrapper() { # modified 2023-01-21
    echo "Initializing Virtualenvwrapper"
    # if homebrew is not installed
    if [ -z "${HOMEBREW_PREFIX+x}" ] && [ ! "$(brew --prefix &>/dev/null)" ]; then
        SYS_PYTHON=$(which python3)
        PYTHON="$SYS_PYTHON"
        echo "Homebrew Prefix is unset. Defaulting to system's $($PYTHON --version)"
        SYS_PYTHON=$(which python3)
        PYTHON="$SYS_PYTHON"
        if [ ! "$(_is_virtualenv)" ]; then
            echo "Virtualenv is not set. Installing..."
            $PYTHON -m pip install virtualenv
            # if virtualenvwrapper is not installed
            if [ ! $(_is_virtualenvwrapper) ]; then
                echo "virtualenvwrapper is not installed. Installing..."
                $PYTHON -m pip install virtualenvwrapper
            fi
        else
            export VIRTUALENV_PREFIX="$HOME/.local/bin/"
            export VIRTUALENV=$VIRTUALENV_PREFIX"/virtualenv"
            export VIRTUALENVWRAPPER_SCRIPT_PREFIX="$HOME/.local/bin/"
        fi
    else
        # Save Homebrew Python
        # See https://docs.brew.sh/Homebrew-and-Python
        HOMEBREW_PYTHON="$(brew --prefix)/opt/python/libexec/bin/python" # unversioned symlink for python
        export HOMEBREW_PYTHON
        PYTHON=$HOMEBREW_PYTHON
        echo "Using Homebrew's $($HOMEBREW_PYTHON --version)"
        export HOMEBREW_VIRTUALENV
        HOMEBREW_VIRTUALENV=$(brew --prefix)/bin/virtualenv
        VIRTUALENV=$HOMEBREW_VIRTUALENV
        echo "Using Homebrew's '$HOMEBREW_VIRTUALENV'"
        export VIRTUALENVWRAPPER_SCRIPT_PREFIX=$(brew --prefix)"/bin"
    fi
    _set_virtualenvwrapper
    printf "Attempting to source virtualenvwrapper.sh at %s:\n" "$VIRTUALENVWRAPPER_SCRIPT_PREFIX"
    _source_virtualenvwrapper
}

### Set virtualenvwrapper helper fn
_set_virtualenvwrapper() {
    PROJECT_HOME="$DEV_WORKSPACE/Python/Projects"
    WORKON_HOME="$VENV_FOLDER/System"
    VIRTUALENVWRAPPER_SCRIPT=$VIRTUALENVWRAPPER_SCRIPT_PREFIX"/virtualenvwrapper.sh"
    VIRTUALENVWRAPPER_PYTHON=$PYTHON
    VIRTUALENVWRAPPER_VIRTUALENV=$VIRTUALENV
}

### Source virtualenvwrapper.sh
_source_virtualenvwrapper() {
    if [ -z "${VIRTUALENVWRAPPER_SCRIPT_PREFIX+x}" ]; then
        echo "VIRTUALENVWRAPPER_SCRIPT_PREFIX is unset."
    elif [ -f "$VIRTUALENVWRAPPER_SCRIPT" ]; then
        source "$VIRTUALENVWRAPPER_SCRIPT_PREFIX/virtualenvwrapper_lazy.sh"
        echo "Successfully initialized virtualenvwrapper"
    else
        echo "virtualenvwrapper.sh not found"
    fi
}

## Pyenv helper functions :

# Initializes pyenv
### _init_pyenv()
_init_pyenv() {
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    if command -v pyenv 1>/dev/null 2>&1; then
        eval "$(pyenv init --path)"
    fi
}

_init_pyenv_virtualenvwrapper() {
    echo "Initializing virtualenvwrapper with pyenv"
    _set_pyenv_virtualenvwrapper

    # pyenv-virtualenvwrapper plugin needs to be installed
    pyenv virtualenvwrapper_lazy

    echo "Done initializing virtualenvwrapper!"
    printf "=====\n"
}

_set_pyenv_virtualenvwrapper() {
    VIRTUALENVWRAPPER_PYTHON=$(pyenv which python)
    PYTHON=$VIRTUALENVWRAPPER_PYTHON
    VIRTUALENVWRAPPER_VIRTUALENV=$(pyenv which virtualenv)
    VIRTUALENV=$VIRTUALENVWRAPPER_VIRTUALENV
}

_pyenv_installed() {
    if [ -d "$HOME/.pyenv" ]; then
        echo "Pyenv is installed"
        return 0
    else
        echo "Pyenv is not installed"
        return 1
    fi
}

_pyenv_virtualenv_installed() {
    if ! isEmpty "$(pyenv root)/plugins/pyenv-virtualenv"; then
        echo "Pyenv-virtualenv is installed"
        return 0
    else
        echo "Pyenv-virtualenv is not installed"
        return 1
    fi
}

## https://github.com/pyenv/pyenv-virtualenv
_install_pyenv_virtualenv() {
    if ! _pyenv_virtualenv_installed; then
        echo "Installing pyenv-virtualenv"
        git clone https://github.com/pyenv/pyenv-virtualenv.git "$(pyenv root)"/plugins/pyenv-virtualenv
        git clone https://github.com/pyenv/pyenv-virtualenvwrapper.git "$(pyenv root)"/plugins/pyenv-virtualenvwrapper # optional
    else
        return 0
    fi
}

_pyenv_virtualenvwrapper_installed() {
    if [ -d "$(pyenv root)/plugins/pyenv-virtualenvwrapper/bin/" ]; then
        echo "pyenv-virtualenvwrapper is installed"
        return 0
    else
        echo "pyenv-virtualenvwrapper is not installed"
        return 1
    fi
}

_set_pyenv_venv() {
    printf "=====\n"
    echo "Setting and initializing pyenv virtual environment with pyenv"
    pyenv shell "$PYENV_VERSION"
    python -m pip install --upgrade pip
    # install pyenv-virtualenv if not found
    if ! _pyenv_virtualenv_installed &>/dev/null; then
        _install_pyenv_virtualenv
    fi

    printf "====>\n"
    if _pyenv_virtualenvwrapper_installed; then
        printf "====>\n"
        _init_pyenv_virtualenvwrapper
    fi

    echo "Done."
    printf "=====\n"
}

# Set the Shell to latest Python2 from pyenv.
# Installs virtualenv and virtualenvwrapper if not already installed
python2_latest() {
    PYENV_VERSION=$PYENV_VERSION_2
    pyenv shell "$PYENV_VERSION"
}

# Set the Shell to preferred Python3 from pyenv.
# Installs virtualenv and virtualenvwrapper if not already installed
python3_base() {
    PYENV_VERSION=$PYENV_VERSION_3
    pyenv shell "$PYENV_VERSION"
}

# Set the Shell to latest Python3 from pyenv.
# This function requires https://github.com/momo-lab/pyenv-install-latest
python3_latest() {
    PYENV_VERSION_3_LATEST=$(pyenv install-latest -l | grep -E '^\s+[0-9]+\.[0-9]+\.[0-9]+$' | tail -1 | xargs)
    # check if latest python version is installed with pyenv
    if pyenv versions | grep -q "$PYENV_VERSION_3_LATEST"; then
        echo "Latest python version ($PYENV_VERSION_3_LATEST) is already installed"
    else
        echo "Installing latest python version"
        pyenv install-latest "$PYENV_VERSION_3_LATEST"
    fi
    PYENV_VERSION=$PYENV_VERSION_3_LATEST
    pyenv shell "$PYENV_VERSION"
}

# Set the Shell to the system Python
set_system_python() {
    pyenv global system
    pyenv shell system
}

pyenv_info() {
    # check if $PYENV_VERSION is set and if pyenv is installed
    if ! _pyenv_installed &>/dev/null; then
        echo "Seems that pyenv is not installed"
        return
    fi

    if [[ "$(pyenv version-name)" =~ 'system' ]]; then
        echo "Using system python"
        print "====>\n" && py_info
        printf "=====\n"
        return
    fi

    if [ -z "$PYENV_VERSION" ]; then
        echo "PYENV_VERSION is not set"
        return
    fi

    local GREEN="\033[0;32m"
    local NOCOLOR='\033[0m'

    echo "${GREEN}Pyenv Info: ${NOCOLOR}"
    printf "-----\n"
    echo "${GREEN}Using: ${NOCOLOR}"
    pyenv which python
    echo "${GREEN}Version: ${NOCOLOR}"
    $(pyenv which python) --version
    echo "${GREEN}with: ${NOCOLOR}"
    # pyenv virtualenv --version
    $(pyenv which virtualenv) --version
    echo "${GREEN}Virtualenvwrapper Info: ${NOCOLOR}"
    $(pyenv which python) -m pip show virtualenvwrapper | grep -e Version -e Location
    echo "${GREEN}and: ${NOCOLOR}"
    $(pyenv which python) -m pip --version
    echo "${GREEN}type 'pip list' for a list of installed packages${NOCOLOR}"
    printf "=====\n"
}

_venv_info() {
    local GREEN="\033[0;32m"
    local NOCOLOR='\033[0m'

    echo "${GREEN}Virtual environment Info: ${NOCOLOR}"
    printf "-----\n"
    echo "${GREEN}Using: ${NOCOLOR}"
    PYTHON=$(pyenv which python)
    echo "$PYTHON"
    echo "${GREEN}Version: ${NOCOLOR}"
    $PYTHON --version
    echo "${GREEN}and: ${NOCOLOR}"
    PIP=$(pyenv which pip)
    $PIP --version
    echo "${GREEN}type 'pip list' for a list of installed packages${NOCOLOR}"
    printf "=====\n"
}

# function to create a virtual environment with pyenv
# Usage: pyenv_venv
# -- Echoes python and virtual environment related info
pyenv_venv() {
    echo "Creating virtual python environment with pyenv"
    echo "Press 2 or 3 followed by the virtual environment name (optional) to select defaults"
    echo "Press 1 to use latest python"
    echo "Press s to choose from installed versions"
    echo "Press d to delete a virtual environment"
    echo "Press q to quit"
    # wait for input
    printf "Enter your choice: "
    read -r selection
    case $selection in
    1) printf "====>\n" && python3_latest || return 1 ;;
    2) printf "====>\n" && python2_latest || return 1 ;;
    3) printf "====>\n" && python3_base || return 1 ;;
    s|S) printf "====>\n" && _pyenv_version_selection || return 1 ;;
    d|D) printf "====>\n" && _delete_pyenv_venv && return;;
    q|Q) return ;;
    *) echo "invalid choice" && return 1 ;;
    esac

    # Prompt user to continue creating virtual environment if selection is not s, d or q
    printf "Press y to create new virtual environment, n to continue without creating a new one \n"
    printf "or q to quit. Choice: "
    local new_venv
    read -r new_venv
    case $new_venv in
    y | Y) # Enter virtual environment name or press enter to use default
        printf "---->\n"
        echo "Enter virtual environment name (optional): "
        local venv_name
        read -r venv_name

        if [ "$venv_name" ]; then
            echo "Naming environment as: $venv_name"
        else # use default name
            echo "Using default name"
        fi

        # Create virtual environment
        if [[ "$(pyenv version-name)" =~ 'system' ]]; then
            printf "====>\n"
            mkvenv "$venv_name"
        else
            printf "====>\n"
            _set_pyenv_venv
            printf "====>\n"
            echo "Creating virtual environment with pyenv"
            _create_pyenv_venv "$(pyenv version-name)" "$venv_name"
        fi

        printf "====>\n"
        _venv_info
        ;;
    n | N)
        echo "Not creating new virtual environment" &&
            if [[ "$(pyenv version-name)" =~ 'system' ]]; then
                echo "Using system-wide python" &&
                    printf "====>\n" && _set_python_alias && printf "====>\n" && py_info
            else
                WORKON_HOME="$VENV_FOLDER/Pyenv/$PYENV_VERSION"
                printf "====>\n" &&
                    _set_pyenv_venv && printf "====>\n" && pyenv_info
            fi
        ;;
    q | Q) echo "Exiting..." && return 0 ;;
    *) echo "Invalid choice" && return 1;;
    esac

    echo "Done!"
    printf "=====\n"
}

# pyenv version selection
_pyenv_version_selection() {
    local -a versions

    for version in $(pyenv versions --bare --skip-aliases); do
        versions+=("$version")
    done

    echo "There are ${#versions[*]} versions available."

    # display array
    # echo "${versions[@]}"

    # Display the active version
    local current_version
    current_version=$(pyenv version-name)
    echo "Current version: $current_version"

    printf "Select version to use or 'q' to exit - 'c' to use current version. \n"
    PS3="Selection: "
    select version in "${versions[@]}"; do
        if [ -n "$version" ]; then
            echo "You selected: $version"
            # check if the version is from an existing virtual environment
            if [[ "$version" =~ 'venv' ]]; then
                echo "This is an existing virtual environment. Activating..."
                pyenv activate "$version"
                echo "To deactivate the virtual environment, run: pyenv deactivate"
                printf "====>\n"
                _venv_info
                printf "=====\n"
                return 1
            else
                pyenv shell "$version" &&
                echo "current shell version is now: $PYENV_VERSION" &&
                break
            fi
        elif [ "$REPLY" = "q" ]; then
            return 1
        # TODO detect if user pressed enter
        # for some reason, this is not working in a select loop
        # elif [ -z "$REPLY" ]; then
        #     echo "Using current version: $current_version"
        #     break
        elif [ "$REPLY" = "c" ]; then
            echo "Keeping current version: $current_version" &&
                printf "====>\n" &&
                # setting python alias avoids funny behaviour of pyversion
                # when python command is not found in PATH
                _set_python_alias &&
                break
        else
            echo "Invalid option. Try another one - 'q': exit."
        fi
    done

    printf "=====\n"
}

# Redefines $WORKON_HOME to isolate virtual environments by python version:
### create_pyenv_venv()
# This function takes two parameters:
# $1 is the python version for the environment (required)
# $2 is the name of the virtual environment (optional)
# Usage: _create_pyenv_venv <python version> [<virtual environment name>]
# Example: _create_pyenv_venv 3.8.6 [myvenv]
_create_pyenv_venv() {
    PYENV_VERSION="$1"

    if [ "$2" ]; then
        venv_name="$2"
    else
        venv_name="test_$(_add_underscore_pyversion)"
    fi

    # set $WORKON_HOME to the correct folder
    WORKON_HOME="$VENV_FOLDER/Pyenv/$PYENV_VERSION"

    printf "Virtual environments will be created using $(pyversion) in:\n '%s' \n" \
        "$WORKON_HOME"

    printf "---->\n"
    echo "Enter project folder name (optional) - Enter to use the default name: ($venv_name)"
    local project_folder
    read -r project_folder

    if [ -z "$project_folder" ]; then
        project_folder=$venv_name
    fi

    printf "====>\n"
    isEmpty "$project_folder"
    printf "====>\n"
    echo "project folder will be: '$project_folder'"
    goto_dir "$PROJECT_HOME/$project_folder"

    printf "---->\n"
    echo "Creating $venv_name environment with $(pyversion)"
    # Create and activate virtual environment
    venv_name="${venv_name}_venv"
    pyenv virtualenv "$PYENV_VERSION" "$venv_name"
    pyenv activate "$venv_name"
    # Alternatively, use available virtualenvwrapper. Conmment the two previous lines to use this.
    # mkvirtualenv "$venv_name"
    # workon "$venv_name"

    echo "Done activating virtual environment: $venv_name."
    echo "To delete the virtual environment, run: pyenv uninstall $venv_name"
    echo "To deactivate the virtual environment, run: pyenv deactivate"
    printf "=====\n"
}

# Delete a virtual environment created with pyenv
### _delete_pyenv_venv()
# This function takes one parameter:
# $1 is the name of the virtual environment (optional)
# Usage: _delete_pyenv_venv <virtual environment name>
# Example: _delete_pyenv_venv myvenv
_delete_pyenv_venv() {
    if [ "$1" ]; then
        venv_name="$1"
    else
        local -a versions

        for version in $(pyenv versions --bare --skip-aliases); do
            versions+=("$version")
        done

        echo "There are ${#versions[*]} versions available."

        # Display the active version
        local current_version
        current_version=$(pyenv version-name)
        echo "Current version: $current_version"

        printf "Select version to delete or 'q' to exit. \n"
        PS3="Selection: "
        select version in "${versions[@]}"; do
            if [ -n "$version" ]; then
                echo "You selected: $version"
                if [[ "$version" =~ 'venv' ]]; then
                    venv_name="$version"
                    break
                else
                    echo "This is not a virtual environment. Try another one."
                    echo "To remove it, run: 'pyenv uninstall $version'"
                fi
                break
            elif [ "$REPLY" = "q" ]; then
                return 0
            else
                echo "Invalid option. Try another one - 'q': exit."
            fi
        done
    fi

    if [ -z "$venv_name" ]; then
        echo "No virtual environment selected. Exiting."
        return 0
    else
        echo "Deleting virtual environment: $venv_name"
        pyenv virtualenv-delete "$venv_name"
    fi
}

# Usage: mkvenv <virtual environment name>
mkvenv() {
    set_system_python
    if [ "$1" ]; then
        venv_name="$1_venv"
    else
        venv_name="test_$(_add_underscore_pyversion)_venv"
    fi

    echo "Creating virtual environment with system-wide python"
    # Use virtualenvwrapper to create and activate virtual environment
    if _is_virtualenvwrapper_installed; then
        mkvirtualenv "$venv_name" && workon "$venv_name"
    else
        #use python venv
        python -m venv "$venv_name" && source "$venv_name"/bin/activate
    fi
    printf "=====\n"
}

### docker-py-env()
# This function takes one parameter:
# $1 is the name of the virtual environment (optional)
# Usage: docker-py-env [<virtual environment name>]
# Example: docker-py-env myvenv
docker-py-env() {
    echo "Creating python environment with docker"
    if [ "$1" ]; then
        goto_dir "$PROJECT_HOME/$1"
    fi
    docker run --rm --name "$(slug "$(here)")" -it -v "$(here)_python-env":/usr/local/lib -v "${PWD}":/usr/src/app -w /usr/src/app python:latest bash
}

### docker-py3.8-env()
# This function takes one parameter:
# $1 is the name of the virtual environment (optional)
# Usage: docker-py-env [<virtual environment name>]
# Example: docker-py-env myvenv
docker-py3.8-env() {
    echo "Creating python 3.8 environment with docker"
    if [ "$1" ]; then
        goto_dir "$PROJECT_HOME/$1"
    fi
    docker run --rm --name "$(slug "$(here)")" -it -v "$(here)_python-env":/usr/local/lib -v "${PWD}":/usr/src/app -w /usr/src/app python:3.8 bash
}

### docker-py-env-del()
# This function takes one parameter:
# $1 is the name of the virtual environment (optional)
# Usage: docker-py-env-del [<virtual environment name>]
docker-py-env-del() {
    docker volume rm "$(here)_python-env"
}

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
    local var=$@
    var="${var#"${var%%[![:space:]]*}"}" # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}" # remove trailing whitespace characters
    echo -n "$var"
}

slugify() {
    echo "$1" | iconv -t ascii//TRANSLIT | sed -E 's/[^a-zA-Z0-9-]+/-/g' | sed -E 's/^-+|-+$//g' | tr A-Z a-z
}

slug() {
    echo $(slugify ${${1:-$PWD}: -200})
}


#--- Directories

# `o` with no arguments opens the current directory, otherwise opens the given
# location
function o() {
    if [ $# -eq 0 ]; then
        open .
    else
        open "$@"
    fi
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
    tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX
}

# Copy and go to the directory
cpg() {
    if [ -d "$2" ]; then
        cp "$1" "$2" && cd "$2"
    else
        cp "$1" "$2"
    fi
}

# Move and go to the directory
mvg() {
    if [ -d "$2" ]; then
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
    mkdir -p "$@" && cd "$_"
}

# Go to the specified directory if it exists or creates it and enters it
function goto_dir() {
    if [ -d "$1" ]; then
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
        d=$d/..
    done
    d=$(echo $d | sed 's/^\///')
    if [ -z "$d" ]; then
        d=..
    fi
    cd $d
}

# Get current directory name without full path
### here()
here() {
    local here=${PWD##*/}
    printf '%q\n' "$here"
}

# Automatically do an ls after each cd
cd() {
    if [ -n "$1" ]; then
        builtin cd "$@" && printf "Listing Directory:\n" && ls
    else
        echo "No directory specified - defaulting to $HOME"
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
        "$src_dir" "$dest_dir"
}

# Works on hidden files, directories and regular files
### isEmpty()
# This function takes one parameter:
# $1 is the directory to check or defaults to current directory
# -- Echoes if the directory has files or not
function isEmpty() {
    dir="${1:-"$PWD"}" # defaults to current dir if no argument

    if [ "$(ls -A "$dir")" ]; then
        echo "The directory $dir contains files:"
        ls -A "$dir"
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
    if ! (isEmpty "${@:-"$PWD"}"); then
        ls -la
        # Remove all files including hidden .files
        rm -vrf "${PWD:?}/"* # this form ensures it never expand to root folder
        rm -vrf "${PWD:?}/".*
    fi
}

#--- Network

# TODO 7: Refactor netinfo fn
# # Show current network information
# netinfo() { # TODO 5: Refactor to work on MAC
#   echo "--------------- Network Information ---------------"
#   /sbin/ifconfig | awk /'inet addr/ {print $2}'
#   echo ""
#   /sbin/ifconfig | awk /'Bcast/ {print $3}'
#   echo ""
#   /sbin/ifconfig | awk /'inet addr/ {print $4}'

#   /sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
#   echo "---------------------------------------------------"
# }

# TODO 8: Refactor whatismyip fn
# IP address lookup
# alias whatismyip="whatsmyip"
# function whatsmyip() {
#   # Dumps a list of all IP addresses for every device
#   # /sbin/ifconfig |grep -B1 "inet addr" |awk '{ if ( $1 == "inet" ) { print $2 } else if ( $2 == "Link" ) { printf "%s:" ,$1 } }' |awk -F: '{ print $1 ": " $3 }';

#   # Internal IP Lookup
#   echo -n "Internal IP: "
#   /sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'

#   # External IP Lookup
#   echo -n "External IP: "
#   wget http://smart-ip.net/myip -O - -q
# }

# View Apache logs
apachelog() {
    if [ -f /etc/httpd/conf/httpd.conf ]; then
        cd /var/log/httpd && ls -xAh && multitail --no-repeat -c -s 2 /var/log/httpd/*_log
    else
        cd /var/log/apache2 && ls -xAh && multitail --no-repeat -c -s 2 /var/log/apache2/*.log
    fi
}

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
function getcertnames() {
    if [ -z "${1}" ]; then
        echo "ERROR: No domain specified."
        return 1
    fi

    local domain="${1}"
    echo "Testing ${domain}…"
    echo "" # newline

    local tmp=$(echo -e "GET / HTTP/1.0\nEOT" |
        openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1)

    if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
        local certText=$(echo "${tmp}" |
            openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
			no_serial, no_sigdump, no_signame, no_validity, no_version")
        echo "Common Name:"
        echo "" # newline
        echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//"
        echo "" # newline
        echo "Subject Alternative Name(s):"
        echo "" # newline
        echo "${certText}" | grep -A 1 "Subject Alternative Name:" |
            sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2
        return 0
    else
        echo "ERROR: Certificate not found."
        return 1
    fi
}

# TODO 9: Refactor for python3
# Start an HTTP server from a directory, optionally specifying the port
# function server() {
#   local port="${1:-8000}"
#   sleep 1 && open "http://localhost:${port}/" &
#   # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
#   # And serve everything as UTF-8 (although not technically correct, this doesn't break anything for binary files)
#   python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
# }

# Start a PHP server from a directory, optionally specifying the port
# (Requires PHP 5.4.0+.)
# function phpserver() {
# 	local port="${1:-4000}";
# 	local ip=$(ipconfig getifaddr en1);
# 	sleep 1 && open "http://${ip}:${port}/" &
# 	php -S "${ip}:${port}";
# }

#--- Git

# Determine git branch.
parse_git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# gitignore()
# Retrieves .gitignore content from https://www.toptal.com/developers/gitignore and writes it to .gitignore
# Usage: gitignore  [<software>]
# Example: gitignore python,django > .gitignore
# Example: gi java,python >> .gitignore
function gitignore() { curl -sL https://www.toptal.com/developers/gitignore/api/$@; }

# Provides completion for zsh https://docs.gitignore.io/use/advanced-command-line

_gitignoreio_get_command_list() {
    curl -sL https://www.toptal.com/developers/gitignore/api/list | tr "," "\n"
}

_gitignoreio() {
    compset -P '*,'
    compadd -S '' "$(_gitignoreio_get_command_list)"
}

compdef _gitignoreio gi


# -- $PATH

# function to remove duplicates in and echo $PATH
### no_dupes_path()
# Note: Inspired from https://www.linuxjournal.com/content/removing-duplicate-path-entries
no_dupes_path() {
    local no_dupes_path
    no_dupes_path=$(echo "$PATH" | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')
    echo "$no_dupes_path"
}

# function to echo $PATH one entry per line
### show_path()
# Note: Inspired from https://www.linuxjournal.com/content/removing-duplicate-path-entries
show_path() {
    awk -v RS=: '{print}' <<<"$PATH"
}

# function to set $PATH with no dupes and echo one entry per line
### set_no_dupes_path()
# Note: Inspired from https://www.linuxjournal.com/content/removing-duplicate-path-entries
set_no_dupes_path() {
    PATH=$(no_dupes_path)
    export PATH
    show_path
}

#######################################################
# SPECIAL LAMP FUNCTIONS
#######################################################

# Edit the Apache configuration
apacheconfig() {
    if [ -f /etc/httpd/conf/httpd.conf ]; then
        sedit /etc/httpd/conf/httpd.conf
    elif [ -f /etc/apache2/apache2.conf ]; then
        sedit /etc/apache2/apache2.conf
    else
        echo "Error: Apache config file could not be found."
        echo "Searching for possible locations:"
        sudo updatedb && locate httpd.conf && locate apache2.conf
    fi
}

# Edit the PHP configuration file
phpconfig() {
    if [ -f /etc/php.ini ]; then
        sedit /etc/php.ini
    elif [ -f /etc/php/php.ini ]; then
        sedit /etc/php/php.ini
    elif [ -f /etc/php5/php.ini ]; then
        sedit /etc/php5/php.ini
    elif [ -f /usr/bin/php5/bin/php.ini ]; then
        sedit /usr/bin/php5/bin/php.ini
    elif [ -f /etc/php5/apache2/php.ini ]; then
        sedit /etc/php5/apache2/php.ini
    else
        echo "Error: php.ini file could not be found."
        echo "Searching for possible locations:"
        sudo updatedb && locate php.ini
    fi
}

# Edit the MySQL configuration file
mysqlconfig() {
    if [ -f /etc/my.cnf ]; then
        sedit /etc/my.cnf
    elif [ -f /etc/mysql/my.cnf ]; then
        sedit /etc/mysql/my.cnf
    elif [ -f /usr/local/etc/my.cnf ]; then
        sedit /usr/local/etc/my.cnf
    elif [ -f /usr/bin/mysql/my.cnf ]; then
        sedit /usr/bin/mysql/my.cnf
    elif [ -f ~/my.cnf ]; then
        sedit ~/my.cnf
    elif [ -f ~/.my.cnf ]; then
        sedit ~/.my.cnf
    else
        echo "Error: my.cnf file could not be found."
        echo "Searching for possible locations:"
        sudo updatedb && locate my.cnf
    fi
}

# For some reason, rot13 pops up everywhere
rot13() {
    if [ $# -eq 0 ]; then
        tr '[a-m][n-z][A-M][N-Z]' '[n-z][a-m][N-Z][A-M]'
    else
        echo $* | tr '[a-m][n-z][A-M][N-Z]' '[n-z][a-m][N-Z][A-M]'
    fi
}
