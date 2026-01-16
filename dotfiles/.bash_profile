#!/usr/bin/env bash
# Run .bashrc
if [[ -f ~/.bashrc ]]; then
  # shellcheck source=$HOME/.bashrc
  source ~/.bashrc
fi
