#!/usr/bin/env bash

# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$_";
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
	local tmpFile="${@%/}.tar";
	tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1;

	size=$(
		stat -f"%z" "${tmpFile}" 2> /dev/null; # macOS `stat`
		stat -c"%s" "${tmpFile}" 2> /dev/null;  # GNU `stat`
	);

	local cmd="";
	if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
		# the .tar file is smaller than 50 MB and Zopfli is available; use it
		cmd="zopfli";
	else
		if hash pigz 2> /dev/null; then
			cmd="pigz";
		else
			cmd="gzip";
		fi;
	fi;

	echo "Compressing .tar ($((size / 1000)) kB) using \`${cmd}\`…";
	"${cmd}" -v "${tmpFile}" || return 1;
	[ -f "${tmpFile}" ] && rm "${tmpFile}";

	zippedSize=$(
		stat -f"%z" "${tmpFile}.gz" 2> /dev/null; # macOS `stat`
		stat -c"%s" "${tmpFile}.gz" 2> /dev/null; # GNU `stat`
	);

	echo "${tmpFile}.gz ($((zippedSize / 1000)) kB) created successfully.";
}

# Determine size of a file or total size of a directory
function fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh;
	else
		local arg=-sh;
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@";
	else
		du $arg .[^.]* ./*;
	fi;
}

# Use Git’s colored diff when available
hash git &>/dev/null;
if [ $? -eq 0 ]; then
	function diff() {
		git diff --no-index --color-words "$@";
	}
fi;

# Create a data URL from a file
function dataurl() {
	local mimeType=$(file -b --mime-type "$1");
	if [[ $mimeType == text/* ]]; then
		mimeType="${mimeType};charset=utf-8";
	fi
	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
}

# Start an HTTP server from a directory, optionally specifying the port
function server() {
	local port="${1:-8000}";
	sleep 1 && open "http://localhost:${port}/" &
	# Set the default Content-Type to `text/plain` instead of `application/octet-stream`
	# And serve everything as UTF-8 (although not technically correct, this doesn’t break anything for binary files)
	python -c $'import SimpleHTTPServer;\nmap = SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map;\nmap[""] = "text/plain";\nfor key, value in map.items():\n\tmap[key] = value + ";charset=UTF-8";\nSimpleHTTPServer.test();' "$port";
}

# Start a PHP server from a directory, optionally specifying the port
# (Requires PHP 5.4.0+.)
function phpserver() {
	local port="${1:-4000}";
	local ip=$(ipconfig getifaddr en1);
	sleep 1 && open "http://${ip}:${port}/" &
	php -S "${ip}:${port}";
}

# Compare original and gzipped file size
function gz() {
	local origsize=$(wc -c < "$1");
	local gzipsize=$(gzip -c "$1" | wc -c);
	local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l);
	printf "orig: %d bytes\n" "$origsize";
	printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio";
}

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
function getcertnames() {
	if [ -z "${1}" ]; then
		echo "ERROR: No domain specified.";
		return 1;
	fi;

	local domain="${1}";
	echo "Testing ${domain}…";
	echo ""; # newline

	local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
		| openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1);

	if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
		local certText=$(echo "${tmp}" \
			| openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
			no_serial, no_sigdump, no_signame, no_validity, no_version");
		echo "Common Name:";
		echo ""; # newline
		echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//";
		echo ""; # newline
		echo "Subject Alternative Name(s):";
		echo ""; # newline
		echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
			| sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2;
		return 0;
	else
		echo "ERROR: Certificate not found.";
		return 1;
	fi;
}

# Normalize `open` across Linux, macOS, and Windows.
# This is needed to make the `o` function (see below) cross-platform.
if [ ! $(uname -s) = 'Darwin' ]; then
	if grep -q Microsoft /proc/version; then
		# Ubuntu on Windows using the Linux subsystem
		alias open='explorer.exe';
	else
		alias open='xdg-open';
	fi
fi

# `o` with no arguments opens the current directory, otherwise opens the given
# location
function o() {
	if [ $# -eq 0 ]; then
		open .;
	else
		open "$@";
	fi;
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
	tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}

# ################################
# Crappy functions written by Zell
# ################################

# Find port in use (used to kill pid)
function findpid () {
  lsof -i tcp:"$*"
}

# USed to kill pid
function killpid () {
  kill -9 "$@"
}

function dlmp3 () {
  song="$1"
  youtube-dl -x --extract-audio --audio-format mp3 "ytsearch:$song"
}
# Function to downloads a .mp4 file
function dlmp4 () {
  video="$1"
  youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' "ytseacrh:$video"
}

# Python (Homebrew):

# Pyenv helper functions (modified 2021-03-07):

python2.latest() {
  pyenv shell 2.7.18
  pip install virtualenv virtualenvwrapper
  pyenv virtualenvwrapper
  echo "Set Python version to $(pyversion)"
}

python3.base() {
  pyenv shell 3.8.6
  pip install virtualenv virtualenvwrapper
  pyenv virtualenvwrapper
  echo "Set Python version to $(pyversion)"
}

python3.latest() {
  pyenv shell system
  pyenv virtualenvwrapper
  echo "Set Python version to latest: $(pyversion)"
}

# Save python -V output in a variable
pyversion() {
  version=$(python --version 2>&1) # needs redirect because defaults to stderr
  echo "$version"
}

# helper to add underscore to a string
add.underscore() {
  str=$1
  echo "${str// /_}"
}

# Returns Python version with underscore
add.underscore.pyversion() {
  pyv=$(pyversion)
  add.underscore "$pyv"
}

# pyenv and pyenv-virtualenvwrapper related functions
# Redefines $WORKON_HOME to isolate virtual environments by python version:
# TODO 2: Refactor to DRY with if statement
py3_venv() {
  # default to Python 3
  python3.latest # change to python3.base if needed and source functions.sh and $SHELL to use
  export WORKON_HOME=$VENV_FOLDER$(add.underscore.pyversion)
  echo "\nVirtual environments will be created using $(pyversion) in:\n $WORKON_HOME/"
  echo "Creating test environment with $(pyversion)"
  mkvirtualenv test_"$(pyenv shell)"_venv
  echo "Done."
}

py2_venv() {
  # default to Python 2
  python2.latest
  export WORKON_HOME=$VENV_FOLDER$(add.underscore.pyversion)
  echo "\nVirtual environments will be created using $(pyversion) in:\n $WORKON_HOME/"
  echo "Creating test environment with $(pyversion)"
  mkvirtualenv test_"$(pyenv shell)"_venv
  echo "Done."
}

# Function to echo the current time
### timestamp()
# Just echoes the formatted time
timestamp() {
  date "+%Y-%m-%d_%H:%M:%S" 
}

# Get current directory name without full path
### here()
here() {
  local here=${PWD##*/}
  printf '%q\n' "$here"
}