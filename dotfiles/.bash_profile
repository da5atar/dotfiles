#!/usr/bin/env bash
# Run .bashrc
if [[ -f ~/.bashrc ]]; then
  # shellcheck source=/home/mass/.bashrc
  source ~/.bashrc
fi
