#!/usr/bin/env bash

# ---- Files  ----
# Count all files (recursively) in the current folder
# shellcheck disable=SC2154
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

# Show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

# ---- Processes ----
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias ps='ps auxf' # Show process info

# Search running processes
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# ---- Dev ----
# Set python alias if python is not found
if ! python --version &>/dev/null; then
    alias python='python3'
    alias pip='pip3'
fi

# Postgres
alias psql-doc='xdg-open /usr/share/doc/postgresql-doc-*/html/index.html'
