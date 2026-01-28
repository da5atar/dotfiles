#!/usr/bin/env bash

# ---- Easier navigation ----
alias home='cd ~'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -" # Change directory to the previous directory

# ---- File permissions ----
alias mx='chmod a+x'     # Make executable
alias 000='chmod -R 000' # No permissions
alias 644='chmod -R 644' # Read and write for owner, read for group and others
alias 666='chmod -R 666' # Read and write for owner, group, and others
alias 700='chmod -R 700' # Read and write for owner, no permissions for group and others
alias 755='chmod -R 755' # Read and execute for owner, group, and others
alias 777='chmod -R 777' # Read, write, and execute for owner, group, and others

# ---- Date and Time ----
alias date='date "+%Y-%m-%d %A %T %Z"' # Formatted date
alias now='date +"%T"'                 # Show current time
alias today='date +"%Y-%m-%d"'         # Show current date
alias week='date +%V'                  # Get week number

# ---- Directories ----
# cd into the old directory
alias bd='cd "$OLDPWD"'

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
alias l='command ls -lF "${colorflag}"'                     # List all files colorized in long format
alias lc='ls -lAF "${colorflag}"'                           # List all files colorized in long format, excluding . and ..
alias lod='ls -lF "${colorflag}" | grep --color=never '^d'' # List only directories
alias la='ls -AlFh --color=always'                          # show hidden files
alias lx='command ls -lXBh "${colorflag}"'                  # sort by extension
alias lsz='ls -lSrh'                                        # sort by size
alias lct='command ls -lcrh "${colorflag}"'                 # sort by change time
alias lat='command ls -lurh'                                # sort by access time
alias lr='ls -lRh'                                          # recursive ls
alias ldt='ls -ltrh'                                        # sort by date
alias lm='ls -alh | more'                                   # pipe through 'more'
alias lw='command ls -xAh "${colorflag}"'                   # wide listing format
alias labc='command ls -lap "${colorflag}"'                 # alphabetical sort
alias lsc="colorls -lA --sd"                                # colorls needs to be installed

alias mkdir='mkdir -p' # Create parent directories as needed

# Show disk space usage
alias dirsize='du -hd 1'                                                         # Show folders and their sizes
alias dirsort='\find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn' # Sort folders by size
alias tree='tree -CAhF --dirsfirst'                                              # Show directory tree with files and directories
alias dirtree='tree -CAFd'                                                       # Show directory tree with only directories

# ---- Files  ----
alias cp='cp -i'        # Interactive copy
alias del='sudo \rm -f' # Really delete
alias find='fd'         # Better find
alias mv='mv -i'        # Interactive move
alias rm='trash'        # safe delete
alias rmd='\rm -ivr'    # remove directory
alias rmi='\rm -iv'     # Interactive remove

# archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# ---- Network ----
alias external-ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias ping='ping -c 10'

# ---- Path ----
# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# ---- Productivity ----
# Git
alias clone='git clone'

# git-ignore https://github.com/sondr3/git-ignore
alias gi='git-ignore'

# https://github.com/lsd-rs/lsd
alias ls='lsd'

alias o='open'

alias reload='exec ${SHELL} -l'

# Enable aliases to be sudo'ed
alias sudo='sudo '


# ---- Search ----
# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias hgrep='history | grep'
alias pgrep='ps aux | grep'
alias pwdgrep='find . | grep'

# ---- Terminal ----
# Record terminal session in a text file using `script`
alias script='script -a terminal_session_$(timestamp).txt'
alias record='script'

# dry run a ZSH login shell and show what is done.
alias show-zsh-login='zsh -xl'

# ---- Xtras ----
# Radiohead
alias radio='tera'
