export XDG_CONFIG_HOME="$HOME/.config"

export XDG_DATA_HOME="$XDG_CONFIG_HOME/local/share"

export XDG_CACHE_HOME="$XDG_CONFIG_HOME/cache"

export HISTFILE="$ZDOTDIR/.zhistory"

export EDITOR="nano"

export LC_ALL="en_US.UTF-8"

export LESS="-R"

export TERM="xterm-256color"

export TERM_PROGRAM="ghostty.app"

export SHELL=/bin/zsh

umask 022

ulimit -n 1024

# echo "zshenv ran in PID: $$ Process: $(ps -p "$$" -o args=) at $(date)" >> "$HOME/zsh-debug.txt"
