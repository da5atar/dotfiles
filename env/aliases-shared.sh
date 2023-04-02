#!/bin/bash

# Easier navigation:
alias home='cd ~'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"

# alias chmod commands
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

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
alias l="ls -lF '${colorflag}'"                             # List all files colorized in long format
alias lc="ls -lAF '${colorflag}'"                           # List all files colorized in long format, excluding . and ..
alias lod="ls -lF '${colorflag}' | grep --color=never '^d'" # List only directories
alias ls="command ls '${colorflag}'"                        # Always use color output for `ls`
alias la='ls -Alh'                                          # show hidden files
alias lcx='ls -aFh --color=always'                          # add colors and file type extensions
alias lx='ls -lXBh'                                         # sort by extension
alias lsz='ls -lSrh'                                        # sort by size
alias lct='ls -lcrh'                                        # sort by change time
alias lat='ls -lurh'                                        # sort by access time
alias lr='ls -lRh'                                          # recursive ls
alias ldt='ls -ltrh'                                        # sort by date
alias lm='ls -alh |more'                                    # pipe through 'more'
alias lw='ls -xAh'                                          # wide listing format
alias ll='ls -Fls'                                          # long listing format
alias labc='ls -lap'                                        #alphabetical sort
alias lf="ls -l | egrep -v '^d'"                            # files only
alias ldir="ls -l | egrep '^d'"                             # directories only

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
alias ip-ext="dig +short myip.opendns.com @resolver1.opendns.com"
# alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Show active network interfaces
# alias ifactive="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"

# Canonical hex dump; some systems have this symlinked
command -v hd >/dev/null || alias hd="hexdump -C"

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# One of @janmoesen's ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
    alias "${method}"="lwp-request -m '${method}'"
done

# Kill all the tabs in Chrome to free up memory
# [C] explained: http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-description
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

# Reload the shell (i.e. invoke as a login shell)
alias reload='exit_shell'

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

##################
# CUSTOM ALIASES
##################
# Source .zshrc, which updates all other commands
alias src="source ~/.zshrc"

# npm run aliases
# alias run="npm run"
# alias rd="npm run dev"
# alias rs="npm run server"
# alias rt="npm run test"
# alias rw="npm run test:watch"

# Aliases for globally installed npm modules
alias t=trash
alias rm=trash
# alias ncu="npm-check -u"

# Aliases for np
# alias pub="np"
# alias patch="np patch"
# alias minor="np minor"
# alias major="np major"

# Gulp aliases
# alias gulp='npx gulp'

# Check opened TCP Ports
alias openedports="sudo netstat -plunt" # TODO 3: FIX 'unknown or uninstrumented protocol error'

# Record terminal session in a text file using `script`
alias script='script -a terminal_session_$(timestamp)'
alias record=script

# print python info and launch python
alias py='py_info && printf "===Starting R.E.P.L===\n" && python'

# dry run a ZSH login shell and show what is done.
alias zshl='zsh -xl'

# Really delete
alias del='sudo rm -f'

# Radiohead
alias radio='tera'

# Better find
alias fd='find'

# Git
alias clone='git clone'

# gitignore
alias gi='gitignore'

# Docker

## commands
alias docker-containers='docker ps -a'

## Python Bind Mounts
alias docker-python3.8='docker run --rm -it -v "${CURRENT_DEV_PROJECT}":/usr/src/app -w /usr/src/app python:3.8 python'
alias docker-python3.9='docker run --rm -it -v "${CURRENT_DEV_PROJECT}":/usr/src/app -w /usr/src/app python:3.9 python'
alias docker-python3.10='docker run --rm -it -v "${CURRENT_DEV_PROJECT}":/usr/src/app -w /usr/src/app python:3.10 python'
alias docker-python='docker run --rm -it -v "${CURRENT_DEV_PROJECT}":/usr/src/app -w /usr/src/app python:latest python'

## Python with Volumes
alias docker-python-vol='docker run --rm -it -v "${CURRENT_DEV_PROJECT}":/usr/src/app -w /usr/src/app -v python-dev-vol:/usr/local/lib python:latest python'

## Ubuntu
alias docker-ubuntu='docker run --rm -it -hostname ubuntu -v "${DEV_PROJECTS}":/ -w / ubuntu:latest -v docker-vol'

## source bash config
alias bashcfg='source ~/.bashcfg'
