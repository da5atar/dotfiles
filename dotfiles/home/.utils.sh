#!/usr/bin/env bash
# shellcheck disable=SC1090,1091,SC2154,SC2181,SC2230,SC2312

# Environment Setup
if [[ "${MACHINE}" == "Mac" ]]; then
    export PATH="/Users/ms/.local/bin:$PATH" # find binaries in .local/bin
fi

# Preferred Editor
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='nano'
else
    export EDITOR='zed'
fi

# ---- atuin ----
# Shell history manager https://atuin.sh
eval "$(atuin init zsh)"

# ---- bat ----
# `bat` https://github.com/sharkdp/bat
export BAT_CONFIG_PATH="{$HOME}/.config/bat/config"

# use bat to colorize help text
alias bathelp='bat --plain --language=help'
help() {
    "$@" --help 2>&1 | bathelp
}
# Use `bat` as a colorized pager for `man`
export MANPAGER="bat -plman"

# ---- fabric ----
# Fabric https://github.com/danielmiessler/Fabric
alias fabric='fabric-ai'
# Define fabric patterns alias (i.e., `summarize` instead of `fabric -p summarize`)
# with option to save the output to Obsidian vault
obsidian_base="${DROPBOX_FOLDER}/My_Files/Inbox/Fabric_AI"
for pattern_file in ~/.config/fabric/patterns/*; do
    pattern_name=$(basename "$pattern_file")
    unalias "$pattern_name" 2>/dev/null
    eval "
    $pattern_name() {
        local title=\$1
        local date_stamp=\$(date +'%Y-%m-%d')
        local output_path=\"\$obsidian_base/\${date_stamp}-\${title}.md\"
        if [ -n \"\$title\" ]; then
            fabric --pattern \"$pattern_name\" -o \"\$output_path\"
        else
            fabric --pattern \"$pattern_name\" --stream
        fi
    }
    "
done

# yt alias to get transcripts, comments, and metadata.
yt() {
    if [ "$#" -eq 0 ] || [ "$#" -gt 2 ]; then
        echo "Usage: yt [-t | --timestamps] youtube-link"
        echo "Use the '-t' flag to get the transcript with timestamps."
        return 1
    fi
    transcript_flag="--transcript"
    if [ "$1" = "-t" ] || [ "$1" = "--timestamps" ]; then
        transcript_flag="--transcript-with-timestamps"
        shift
    fi
    local video_link="$1"
    fabric -y "$video_link" $transcript_flag
}

# ---- fzf ----
# fzf setup https://github.com/junegunn/fzf
source <(fzf --zsh)
export FZF_DEFAULT_OPTS="
    --height 40%
    --layout=reverse
    --border
    --inline-info
    --preview 'bat --style=numbers --color=always --line-range :500 {}'
"
# Use fd instead of find
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# ---- gh ----
# GitHub (gh) CLI Copilot extension https://github.com/github/gh-copilot
# eval "$(gh copilot alias -- zsh)"

# ---- iTerm2 ----
# iTerm2 shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" &&
    source "${HOME}/.iterm2_shell_integration.zsh"

# ---- notes ----
# Shell Notes https://github.com/da5atar/shell-notes
export NOTES_DIRECTORY

# ---- python ----
# Avoid global installs with pip
export PIP_REQUIRE_VIRTUALENV=true

# ---- television ----
# tv https://github.com/alexpasmantier/television
eval "$(tv init zsh)"

# Custom aliases and env variables
source "${HOME}/.aliases.sh" # local specific aliases
source "${HOME}/.env"

# ---- End of file ----
