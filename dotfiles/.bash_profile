#!/usr/bin/env bash
# Fig pre block. Keep at the top of this file.
. "$HOME/.fig/shell/bash_profile.pre.bash"


# Run .bashrc
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# Fig post block. Keep at the bottom of this file.
. "$HOME/.fig/shell/bash_profile.post.bash"
