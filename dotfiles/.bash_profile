#!/usr/bin/env bash

if [ -f ~/.bashcfg ]; then
  source "$PROJECT_ROOT"/dotfiles/.bashcfg
fi

# Run .bashrc
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi
