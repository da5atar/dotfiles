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

# Copy file with a progress bar
cpp() {
  set -e
  strace -q -ewrite cp -- "${1}" "${2}" 2>&1 |
    awk '{
	count += $NF
	if (count % 10 == 0) {
		percent = count / total_size * 100
		printf "%3d%% [", percent
		for (i=0;i<=percent;i++)
			printf "="
			printf ">"
			for (i=percent;i<100;i++)
				printf " "
				printf "]\r"
			}
		}
	END { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}

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

#--- Processes

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

# Save python version output in a variable
pyversion() {
  _pyversion=$(python --version 2>&1) # needs redirect because defaults to stderr
  echo "$_pyversion"
}

# helper to add underscore to a string
add_underscore() {
  str=$1
  echo "${str// /_}"
}

# Returns Python version with underscore
_add_underscore_pyversion() {
  pyv=$(pyversion)
  add_underscore "$pyv"
}

# virtualenvwrapper initializer
init_virtualenvwrapper() { # modified 2021-04-01
  echo "Initializing Virtualenvwrapper"
  if [ -z "${HOMEBREW_PREFIX+x}" ] && [ ! "$(brew --prefix)" ]; then
    test python && PYTHON=$(which python) || PYTHON=$(which python3)
    echo "Homebrew Prefix is unset. Defaulting to system's $($PYTHON --version)"
    if [ "$($PYTHON -m virtualenv)" ]; then
        # Save which virtualenv
        VIRTUALENV=$($PYTHON -m virtualenv)
        echo "Virtualenv is set to '$VIRTUALENV'"
        export VIRTUALENVWRAPPER_SCRIPT_PREFIX="/usr/local/bin"
    else
        echo "Virtualenv is not set"
        return
    fi
  else
    # Save Homebrew Python
    # See https://docs.brew.sh/Homebrew-and-Python
    HOMEBREW_PYTHON="$(brew --prefix)/opt/python/libexec/bin/python" # unversioned symlink for python
    export HOMEBREW_PYTHON
    PYTHON=$HOMEBREW_PYTHON
    echo "Using Homebrew's '$HOMEBREW_PYTHON'"
    export HOMEBREW_VIRTUALENV
    HOMEBREW_VIRTUALENV=$(brew --prefix)/bin/virtualenv
    VIRTUALENV=$HOMEBREW_VIRTUALENV
    echo "Using Homebrew's '$HOMEBREW_VIRTUALENV'"
    export VIRTUALENVWRAPPER_SCRIPT_PREFIX=$(brew --prefix)"/bin"
  fi
  _set_virtualenvwrapper
  printf "Attempting to source virtualenvwrapper.sh at $VIRTUALENVWRAPPER_SCRIPT_PREFIX:\n"
  _source_virtualenvwrapper
}

# Set virtualenvwrapper helper fn
_set_virtualenvwrapper() {
  PROJECT_HOME="$DEV_WORKSPACE/Python/Projects"
  WORKON_HOME=$VENV_FOLDER
  VIRTUALENVWRAPPER_SCRIPT=$VIRTUALENVWRAPPER_SCRIPT_PREFIX"/virtualenvwrapper.sh"
  VIRTUALENVWRAPPER_PYTHON=$PYTHON
  VIRTUALENVWRAPPER_VIRTUALENV=$VIRTUALENV
}

# Source virtualenvwrapper.sh
_source_virtualenvwrapper() {
    if [ -z "${VIRTUALENVWRAPPER_SCRIPT_PREFIX+x}" ]; then
        echo "VIRTUALENVWRAPPER_SCRIPT_PREFIX is unset."
    elif [ -f "$VIRTUALENVWRAPPER_SCRIPT_PREFIX/virtualenvwrapper.sh" ]; then
        source "$VIRTUALENVWRAPPER_SCRIPT_PREFIX/virtualenvwrapper_lazy.sh"
        echo "Successfully initialized virtualenvwrapper"
    else
        echo "virtualenvwrapper.sh not found"
    fi
}

# Print python info
py_info() {
  local GREEN="\033[0;32m"
  local NOCOLOR='\033[0m'
  printf "=====\n"
  echo "${GREEN}Using: ${NOCOLOR}"
  which "$PYTHON"
  echo "${GREEN}Version: ${NOCOLOR}"
  $PYTHON --version
  echo "${GREEN}with: ${NOCOLOR}"
  $VIRTUALENV --version
  echo "${GREEN}Virtualenvwrapper Info: ${NOCOLOR}"
  echo "$VIRTUALENVWRAPPER_SCRIPT"
  echo "${GREEN}and: ${NOCOLOR}"
  $PYTHON -m pip --version
  echo "${GREEN}type 'pip list' for a list of installed packages${NOCOLOR}"
  printf "=====\n"
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

_set_pyenv_virtualenvwrapper() {
  WORKON_HOME="$VENV_FOLDER/Pyenv/$PYENV_VERSION"
  VIRTUALENVWRAPPER_PYTHON=$(pyenv which python)
  PYTHON=$VIRTUALENVWRAPPER_PYTHON
  VIRTUALENVWRAPPER_VIRTUALENV=$(pyenv which virtualenv)
  VIRTUALENV=$VIRTUALENVWRAPPER_VIRTUALENV
}

_init_pyenv_virtualenvwrapper() {
    echo "Initializing pyenv virtualenvwrapper"
    _set_pyenv_virtualenvwrapper
    source $(pyenv which virtualenvwrapper.sh)
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

_set_pyenv() {
    if _pyenv_installed; then
      if $PYENV_VERSION -ne "$(pyenv shell)" 2>/dev/null; then
        pyenv install "$PYENV_VERSION"
      fi
    fi
    pyenv shell "$PYENV_VERSION"
    echo "pyenv shell is set to $(pyenv shell)"
    python -m pip install --upgrade pip
    pip install virtualenv virtualenvwrapper
    echo "Done installing virtualenv and virtualenvwrapper"
    _init_pyenv_virtualenvwrapper
    echo "Set Python version to $(pyversion)"
    pyenv_info # saving the python environment so that next created virtual env uses the same
}

# Set the Shell to latest Python2 from pyenv.
# Installs virtualenv and virtualenvwrapper if not already installed
python2_latest() {
    PYENV_VERSION=$PYENV_VERSION_2
    _set_pyenv
}

# Set the Shell to preferred Python3 from pyenv.
# Installs virtualenv and virtualenvwrapper if not already installed
python3_base() {
    PYENV_VERSION=$PYENV_VERSION_3
    _set_pyenv
}

# Set the Shell to latest Python3 from pyenv.
# Installs virtualenv and virtualenvwrapper if not already installed
# This function requires https://github.com/momo-lab/pyenv-install-latest
python3_latest() {
    pyenv install-latest
    PYENV_VERSION="$(pyenv install-latest --print)"
    _set_pyenv
}

pyenv_info() {
  local GREEN="\033[0;32m"
  local NOCOLOR='\033[0m'
  printf "=====\n"
  echo "${GREEN}Using: ${NOCOLOR}"
  pyenv which python
  export PYTHON="$(pyenv which python)"
  export PIP="$(pyenv which pip)"
  echo "${GREEN}Version: ${NOCOLOR}"
  $PYTHON --version
  echo "${GREEN}with: ${NOCOLOR}"
  export VIRTUALENV="$(pyenv which virtualenv)"
  $VIRTUALENV --version
  echo "${GREEN}Virtualenvwrapper Info: ${NOCOLOR}"
  $PIP show virtualenvwrapper | grep -e Version -e Location
  echo "${GREEN}and: ${NOCOLOR}"
  $PIP --version
  echo "${GREEN}type 'pip list' for a list of installed packages${NOCOLOR}"
  printf "=====\n"
}

# Redefines $WORKON_HOME to isolate virtual environments by python version:
### create.pyenv.venv()
# This function takes two parameters:
# $1 is the python version for the environment
# $2 is the name of the virtual environment
# Example: create.pyenv.venv 3.8.6 myvenv
# -- Echoes python and virtual environment related info
_create_pyenv_venv() {
    case "${1}" in
        2)
            python2_latest
        ;;
        3)
            python3_base
        ;;
        *)
            echo "defaulting to $(pyversion)"
    esac
    printf "=====\n"
    printf "Virtual environments will be created using $(pyversion) in:\n '%s' \n" "$WORKON_HOME"
    printf "=====\n"
    if [ "$2" ]; then
        echo "Creating $2 environment with $(pyversion)"
        mkvirtualenv "$2_venv"
    else
        echo "Creating test environment with $(pyversion)"
        mkvirtualenv "test_$(_add_underscore_pyversion)_venv"
    fi
    printf "=====\n"
    echo "Done."
}

pyenv_venv() {
    if [ -z "$1" ]; then
        echo "Please select enter '2' or '3' for the python version"
    else
        if [ -z "$2" ]; then
            _create_pyenv_venv "$1"
        else
            _create_pyenv_venv "$1" "$2"
        fi
    fi
}

#--- Text Editors

# Use the best version of pico installed
edit() {
  if [ "$(type -t nano)" = "file" ]; then
    nano -c "$@"
  elif [ "$(type -t pico)" = "file" ]; then
    pico "$@"
  else
    vim "$@"
  fi
}

sedit() {
  if [ "$(type -t nano)" = "file" ]; then
    sudo nano -c "$@"
  elif [ "$(type -t pico)" = "file" ]; then
    sudo pico "$@"
  else
    sudo vim "$@"
  fi
}

# Trim leading and trailing spaces (for scripts)
trim() {
  local var=$@
  var="${var#"${var%%[![:space:]]*}"}" # remove leading whitespace characters
  var="${var%"${var##*[![:space:]]}"}" # remove trailing whitespace characters
  echo -n "$var"
}

#--- Directories

# Create and go to the directory
mkdirg() {
  mkdir -p "$1"
  cd "$1"
}

# Create a new directory and enter it
function mkd() {
  mkdir -p "$@" && cd "$_"
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

#Automatically do an ls after each cd
# cd ()
# {
# 	if [ -n "$1" ]; then
# 		builtin cd "$@" && ls
# 	else
# 		builtin cd ~ && ls
# 	fi
# }

# Returns the last 2 fields of the working directory
pwdtail() {
  pwd | awk -F/ '{nlast = NF -1;print $nlast"/"$NF}'
}

#--- Network

# Show current network information
netinfo() { # TODO 5: Refactor to work on MAC
  echo "--------------- Network Information ---------------"
  /sbin/ifconfig | awk /'inet addr/ {print $2}'
  echo ""
  /sbin/ifconfig | awk /'Bcast/ {print $3}'
  echo ""
  /sbin/ifconfig | awk /'inet addr/ {print $4}'

  /sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
  echo "---------------------------------------------------"
}

# IP address lookup
alias whatismyip="whatsmyip"
function whatsmyip() {
  # Dumps a list of all IP addresses for every device
  # /sbin/ifconfig |grep -B1 "inet addr" |awk '{ if ( $1 == "inet" ) { print $2 } else if ( $2 == "Link" ) { printf "%s:" ,$1 } }' |awk -F: '{ print $1 ": " $3 }';

  # Internal IP Lookup
  echo -n "Internal IP: "
  /sbin/ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}'

  # External IP Lookup
  echo -n "External IP: "
  wget http://smart-ip.net/myip -O - -q
}

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

# Start an HTTP server from a directory, optionally specifying the port
function server() {
  local port="${1:-8000}"
  sleep 1 && open "http://localhost:${port}/" &
  # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
  # And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
  python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port"
}

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

# Use Git’s colored diff when available
hash git &>/dev/null
if [ $? -eq 0 ]; then
  function diff() {
    git diff --no-index --color-words "$@"
  }
fi

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
### no_dupes_path()
# Note: Inspired from https://www.linuxjournal.com/content/removing-duplicate-path-entries
show_path() {
  awk -v RS=: '{print}' <<<"$PATH"
}

# function to set $PATH with no dupes and echo one entry per line
### no_dupes_path()
# Note: Inspired from https://www.linuxjournal.com/content/removing-duplicate-path-entries
set_no_dupes_path() {
  PATH=$(no_dupes_path)
  export PATH
  show_path
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
    echo "The directory contains files"
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
clean_dir() {
  if ! (isEmpty "${@:-"$PWD"}"); then
    ls -la
    # Remove all files including hidden .files
    rm -vrf "${PWD:?}/"* # this form ensures it never expand to root folder
    rm -vrf "${PWD:?}/".*
  fi
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
