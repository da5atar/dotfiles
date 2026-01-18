#!/usr/bin/env bash

# Shortcuts
alias f='open -a Finder'

# System
alias os='sw_vers'
alias sys-info='system_profiler SPHardwareDataType'
alias updates='softwareupdate -l'
alias ips='ifconfig | grep inet'

# ---- Productivity Aliases ----

# Calculator
alias bc='bc -l'

# Date/time
alias now='date +"%T"'         # Show current time
alias today='date +"%Y-%m-%d"' # Show current date

# Clipboard
alias copy-file='pbcopy <'   # Copy file contents to clipboard: copy-file file.txt
alias paste-file='pbpaste >' # Paste clipboard to file: paste-file file.txt

# ---- Functions ----

# Extract various archive types (macOS compatible, requires Homebrew for some tools)
extract() {
    if [ -f "$1" ]; then
        case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz) tar xzf "$1" ;;
        *.bz2) bunzip2 "$1" ;; # brew install bzip2
        *.rar) unrar x "$1" ;; # brew install unrar
        *.gz) gunzip "$1" ;;
        *.tar) tar xf "$1" ;;
        *.tbz2) tar xjf "$1" ;;
        *.tgz) tar xzf "$1" ;;
        *.zip) unzip "$1" ;;    # built-in
        *.Z) uncompress "$1" ;; # brew install ncompress
        *.7z) 7z x "$1" ;;      # brew install p7zip
        *) echo "Cannot extract '$1'" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
