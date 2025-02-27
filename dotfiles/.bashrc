#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2154,SC2312

# Original base file credits: https://gist.github.com/zachbrowne/8bc414c9f30192067831fafebd14255c
# with some adaptations from [Nick Janetakis's dotfiles](https://github.com/nickjj/dotfiles.git),
# however I added or modified ~many~ most things. Please read carefully and adapt before using.

if [[ -d ~/.bash_it ]]; then
    # If not running interactively, don't do anything
    case $- in
    *i*) ;;
    *) return ;;
    esac

    # Path to the bash it configuration
    export BASH_IT="${HOME}/.bash_it"

    # Lock and Load a custom theme file.
    # Leave empty to disable theming.
    # location /.bash_it/themes/
    export BASH_IT_THEME='bobby'

    # Some themes can show whether `sudo` has a current token or not.
    # Set `$THEME_CHECK_SUDO` to `true` to check every prompt:
    #THEME_CHECK_SUDO='true'

    # (Advanced): Change this to the name of your remote repo if you
    # cloned bash-it with a remote other than origin such as `bash-it`.
    # export BASH_IT_REMOTE='bash-it'

    # (Advanced): Change this to the name of the main development branch if
    # you renamed it or if it was changed for some reason
    # export BASH_IT_DEVELOPMENT_BRANCH='master'

    # Your place for hosting Git repos. I use this for private repos.
    export GIT_HOSTING='git@git.domain.com'

    # Don't check mail when opening terminal.
    unset MAILCHECK

    # Change this to your console based IRC client of choice.
    export IRC_CLIENT='irssi'

    # Set this to the command you use for todo.txt-cli
    export TODO="t"

    # Set this to the location of your work or project folders
    #BASH_IT_PROJECT_PATHS="${HOME}/Projects:/Volumes/work/src"

    # Set this to false to turn off version control status checking within the prompt for all themes
    export SCM_CHECK=true
    # Set to actual location of gitstatus directory if installed
    #export SCM_GIT_GITSTATUS_DIR="$HOME/gitstatus"
    # per default gitstatus uses 2 times as many threads as CPU cores, you can change this here if you must
    #export GITSTATUS_NUM_THREADS=8

    # Set Xterm/screen/Tmux title with only a short hostname.
    # Uncomment this (or set SHORT_HOSTNAME to something else),
    # Will otherwise fall back on $HOSTNAME.
    #export SHORT_HOSTNAME=$(hostname -s)

    # Set Xterm/screen/Tmux title with only a short username.
    # Uncomment this (or set SHORT_USER to something else),
    # Will otherwise fall back on $USER.
    #export SHORT_USER=${USER:0:8}

    # If your theme use command duration, uncomment this to
    # enable display of last command duration.
    #export BASH_IT_COMMAND_DURATION=true
    # You can choose the minimum time in seconds before
    # command duration is displayed.
    #export COMMAND_DURATION_MIN_SECONDS=1

    # Set Xterm/screen/Tmux title with shortened command and directory.
    # Uncomment this to set.
    #export SHORT_TERM_LINE=true

    # Set vcprompt executable path for scm advance info in prompt (demula theme)
    # https://github.com/djl/vcprompt
    #export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

    # (Advanced): Uncomment this to make Bash-it reload itself automatically
    # after enabling or disabling aliases, plugins, and completions.
    # export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

    # Uncomment this to make Bash-it create alias reload.
    # export BASH_IT_RELOAD_LEGACY=1

    # Load Bash It
    # shellcheck source=/dev/null
    source "${BASH_IT}"/bash_it.sh

else
    echo "bash_it.sh not found"
    # Source shared .bash and .zshconfiguration (.rc)
    source "${HOME}/.init"

    # On Linux
    if [[ -f /etc/os-release ]]; then
        echo "Setting up default Bash config"

        ##############################
        # SOURCED ALIAS'S AND SCRIPTS
        ##############################

        # Source global definitions
        if [[ -f /etc/bashrc ]]; then
            # shellcheck source=/dev/null
            . /etc/bashrc
        fi

        # Enable bash programmable completion features in interactive shells
        if [[ -f /usr/share/bash-completion/bash_completion ]]; then
            # shellcheck source=/dev/null
            . /usr/share/bash-completion/bash_completion
        elif [[ -f /etc/bash_completion ]]; then
            # shellcheck source=/dev/null
            . /etc/bash_completion
        fi

        #######################################################
        # EXPORTS
        #######################################################

        # Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
        shopt -s checkwinsize

        # Causes bash to append to history instead of overwriting it so if you start a new terminal, you have old session history
        shopt -s histappend
        PROMPT_COMMAND='history -a'

        # Allow ctrl-S for history navigation (with ctrl-R)
        stty -ixon

        # To have colors for ls and all grep commands such as grep, egrep and zgrep
        export CLICOLOR=1
        export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'
        export GREP_OPTIONS='--color=auto' # deprecated
        alias grep="/bin/grep --color=auto"
        unset GREP_OPTIONS

        # Only on Linux and if bash-it is not installed
        # linuxbrew
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

        #######################################################
        # Set the ultimate amazing command prompt
        #######################################################

        # Define colors
        function __setprompt {
            local LAST_COMMAND=$? # Must come first!

            # Colors defined in .init
            # Show error exit code if there is one
            if [[ ${LAST_COMMAND} != 0 ]]; then
                # PS1="\[${RED}\](\[${LIGHTRED}\]ERROR\[${RED}\])-(\[${LIGHTRED}\]Exit Code \[${WHITE}\]${LAST_COMMAND}\[${RED}\])-(\[${LIGHTRED}\]"
                PS1="\[${DARKGRAY}\](\[${LIGHTRED}\]ERROR\[${DARKGRAY}\])-(\[${RED}\]Exit Code \[${LIGHTRED}\]${LAST_COMMAND}\[${DARKGRAY}\])-(\[${RED}\]"
                if [[ ${LAST_COMMAND} == 1 ]]; then
                    PS1+="General error"
                elif [[ ${LAST_COMMAND} == 2 ]]; then
                    PS1+="Missing keyword, command, or permission problem"
                elif [[ ${LAST_COMMAND} == 126 ]]; then
                    PS1+="Permission problem or command is not an executable"
                elif [[ ${LAST_COMMAND} == 127 ]]; then
                    PS1+="Command not found"
                elif [[ ${LAST_COMMAND} == 128 ]]; then
                    PS1+="Invalid argument to exit"
                elif [[ ${LAST_COMMAND} == 129 ]]; then
                    PS1+="Fatal error signal 1"
                elif [[ ${LAST_COMMAND} == 130 ]]; then
                    PS1+="Script terminated by Control-C"
                elif [[ ${LAST_COMMAND} == 131 ]]; then
                    PS1+="Fatal error signal 3"
                elif [[ ${LAST_COMMAND} == 132 ]]; then
                    PS1+="Fatal error signal 4"
                elif [[ ${LAST_COMMAND} == 133 ]]; then
                    PS1+="Fatal error signal 5"
                elif [[ ${LAST_COMMAND} == 134 ]]; then
                    PS1+="Fatal error signal 6"
                elif [[ ${LAST_COMMAND} == 135 ]]; then
                    PS1+="Fatal error signal 7"
                elif [[ ${LAST_COMMAND} == 136 ]]; then
                    PS1+="Fatal error signal 8"
                elif [[ ${LAST_COMMAND} == 137 ]]; then
                    PS1+="Fatal error signal 9"
                elif [[ ${LAST_COMMAND} -gt 255 ]]; then
                    PS1+="Exit status out of range"
                else
                    PS1+="Unknown error code"
                fi
                PS1+="\[${DARKGRAY}\])\[${NOCOLOR}\]\n"
            else
                PS1=""
            fi

            # Date
            PS1+="\[${DARKGRAY}\](\[${CYAN}\]\$(date +%a) $(date +%b-'%-m')" # Date
            PS1+="${BLUE} $(date +'%-I':%M:%S%P)\[${DARKGRAY}\])-"           # Time

            # CPU
            PS1+="(\[${MAGENTA}\]CPU $(cpu)%"

            # Jobs
            PS1+="\[${DARKGRAY}\]:\[${MAGENTA}\]\j"

            # Network Connections (for a server - comment out for non-server)
            # PS1+="\[${DARKGRAY}\]:\[${MAGENTA}\]Net $(awk 'END {print NR}' /proc/net/tcp)"

            PS1+="\[${DARKGRAY}\])-"

            # User and server
            local SSH_IP
            SSH_IP=$(echo "${SSH_CLIENT}" | awk '{ print $1 }')
            local SSH2_IP
            SSH2_IP=$(echo "${SSH2_CLIENT}" | awk '{ print $1 }')
            if [[ -n "${SSH2_IP}" ]] || [[ -n "${SSH_IP}" ]]; then
                PS1+="(\[${RED}\]\u@\h"
            else
                PS1+="(\[${RED}\]\u"
            fi

            # Current directory
            PS1+="\[${DARKGRAY}\]:\[${BROWN}\]\w\[${DARKGRAY}\])-"

            # Total size of files in current directory
            PS1+="(\[${GREEN}\]$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')\[${DARKGRAY}\]:"

            # Number of files
            PS1+="\[${GREEN}\]\$(/bin/ls -A -1 | /usr/bin/wc -l)\[${DARKGRAY}\])"

            # Skip to the next line
            PS1+="\n"

            if [[ ${EUID} -ne 0 ]]; then
                PS1+="\[${GREEN}\]>\[${NOCOLOR}\] " # Normal user
            else
                PS1+="\[${RED}\]>\[${NOCOLOR}\] " # Root user
            fi

            # PS2 is used to continue a command using the \ character
            PS2="\[${DARKGRAY}\]>\[${NOCOLOR}\] "

            # PS3 is used to enter a number choice in a script
            PS3='Please enter a number from above list: '

            # PS4 is used for tracing a script in debug mode
            PS4='\[${DARKGRAY}\]+\[${NOCOLOR}\] '
        }
        PROMPT_COMMAND='__setprompt'

        # Set a non-distracting prompt.
        PS1='\[[01;32m\]\u@\h\[[00m\]:\[[01;34m\]\w\[[00m\] \[[01;33m\]$(parse_git_branch)\[[00m\]\$ '

        # If it's an xterm compatible terminal, set the title to user@host: dir.
        case "${TERM}" in
        xterm* | rxvt*)
            PS1="\[\e]0;\u@\h: \w\a\]${PS1}"
            ;;
        *) ;;
        esac
    else
        cat "${PROJECT_ROOT}"/templates/bash-rc-mac >~/.bashrc
    fi

    # Source utilities pyenv, anaconda, thefuck, z, fzf...
    source "${HOME}/.utils"

    # Source cargo environment variables
    # shellcheck source=/dev/null
    [[ -f "${HOME}/.cargo/env" ]] && source "${HOME}/.cargo/env"
fi
