#!/usr/bin/env bash

# ---- Homebrew ----

# bundle: https://docs.brew.sh/Brew-Bundle-and-Brewfile
alias bbd="brew bundle dump --global --force"
alias bbi="brew bundle install --global"
alias bbc="brew bundle check --global --verbose"

# ---- Network ----
alias local-ip="ipconfig getifaddr en0"

# ---- Productivity ----

# Calculator
alias bc='bc -l'

# Clipboard
alias copy-file='pbcopy <'   # Copy file contents to clipboard: copy-file file.txt
alias paste-file='pbpaste >' # Paste clipboard to file: paste-file file.txt

# System
alias os='sw_vers'
alias sys-info='system_profiler SPHardwareDataType'
alias updates='softwareupdate -l'
alias ips='ifconfig | grep inet'
