#!/usr/bin/env bash

# Easier navigation:
alias home='cd ~'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -" # Change directory to the previous directory

# alias chmod commands
alias mx='chmod a+x' # Make executable
alias 000='chmod -R 000' # No permissions
alias 644='chmod -R 644' # Read and write for owner, read for group and others
alias 666='chmod -R 666' # Read and write for owner, group, and others
alias 700='chmod -R 700' # Read and write for owner, no permissions for group and others
alias 755='chmod -R 755' # Read and execute for owner, group, and others
alias 777='chmod -R 777' # Read, write, and execute for owner, group, and others

# Detect which `ls` flavor is in use
# "ls --color > /dev/null 2>&1;" then returns true after brew install coreutils.
# See original version here: https://github.com/mathiasbynens/dotfiles/blob/master/.aliases#L18
if [[ "$(uname -s)" == "Darwin" ]]; then # Mac OS
    colorflag="-G"
    export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'
else
    if ls --color >/dev/null 2>&1; then # GNU `ls`
        colorflag="--color"
        export LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
    fi
fi

# Aliases for multiple directory listing commands
alias l='ls -lF "${colorflag}"'                             # List all files colorized in long format
alias lc='ls -lAF "${colorflag}"'                           # List all files colorized in long format, excluding . and ..
alias lod='ls -lF "${colorflag}" | grep --color=never '^d'' # List only directories
alias ls='command ls "${colorflag}"'                        # Always use color output for `ls`
alias la='ls -Alh'                 # show hidden files
alias lcx='ls -aFh --color=always' # add colors and file type extensions
alias lx='ls -lXBh'                # sort by extension
alias lsz='ls -lSrh'               # sort by size
alias lct='ls -lcrh'               # sort by change time
alias lat='ls -lurh'               # sort by access time
alias lr='ls -lRh'                 # recursive ls
alias ldt='ls -ltrh'               # sort by date
alias lm='ls -alh |more'           # pipe through 'more'
alias lw='ls -xAh'                 # wide listing format
alias ll='ls -Fls'                 # long listing format
alias labc='ls -lap'               #alphabetical sort
alias lf="ls -l | egrep -v '^d'"   # files only
alias ldir="ls -l | egrep '^d'"    # directories only
alias lsc="colorls -lA --sd"       # colorls
alias ls="lsd"                     # lsd

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Enable aliases to be sudo'ed
alias sudo='sudo '

# Get week number
alias week='date +%V'

# Get macOS Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
# alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update; sudo gem cleanup'
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup'

# IP addresses
alias my-external-ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias my-local-ip="ipconfig getifaddr en0"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# Source .zshrc, which updates all other commands
alias src="source ~/.zshrc"

# safe delete
alias rm='trash'

# Record terminal session in a text file using `script`
alias script='script -a terminal_session_$(timestamp).txt'
alias record='script'

# dry run a ZSH login shell and show what is done.
alias show-zsh-login='zsh -xl'

# Really delete
alias del='sudo \rm -f'

# Radiohead
alias radio='tera'

# Better find
alias find='fd'

# Git
alias clone='git clone'

# gitignore
alias gi='gitignore'
