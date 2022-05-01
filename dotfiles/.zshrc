# Source shared .bash and .zshconfiguration (.rc)
source "$HOME/.init"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load.
ZSH_THEME="agnoster"

# Plugins
# plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(
  git
  autojump
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Fix Path to preferred order on MAC
if [[ "$MACHINE" == "Mac" ]];then
    # Starship command prompt
    # Change default starship.toml file location with STARSHIP_CONFIG environment variable
    export STARSHIP_CONFIG="$HOME/.starship.toml";
    eval "$(starship init zsh)"

    # userpath
    export PATH="$USER_PATH:$PATH";

    # Find brew utilities in /user/local/sbin
    export PATH="/usr/local/sbin:$PATH";

    # Ruby
    export PATH="/usr/local/lib/ruby/gems/3.0.0/bin:$PATH" # binaries installed by homebrew gem
    export PATH="/usr/local/opt/ruby/bin:$PATH" # homebrew ruby

    # colorls
    source $(dirname $(gem which colorls))/tab_complete.sh

elif [[ "$MACHINE" == "Linux" ]]; then
    # linuxbrew
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# default to base Python 3 installed with Homebrew
# python3_base

# Source utilities pyenv, anaconda, thefuck, z, fzf...
source "$HOME/.utils"


