#!/usr/bin/env bash

# Shortcuts
alias f='open -a Finder'

# System
alias os='sw_vers'
alias sys-info='system_profiler SPHardwareDataType'
alias updates='softwareupdate -l'
alias ips='ifconfig | grep inet'

# ---- Productivity ----

# Calculator
alias bc='bc -l'

# Clipboard
alias copy-file='pbcopy <'   # Copy file contents to clipboard: copy-file file.txt
alias paste-file='pbpaste >' # Paste clipboard to file: paste-file file.txt

# ---- Network ----
alias local-ip="ipconfig getifaddr en0"
