#!/usr/bin/env bash

# Select nvim config directory
### _select_nvim_config()
# This function does not take any parameters
# -- Prompts the user to select a nvim config directory
_select_nvim_config() {
  # Retrieve all available config directories
  # Assumes config directories contains 'vim' in ~/.config
  nvim_configs="$(fd --max-depth 1 --glob '[ln]vim*' ~/.config)"
  # Add explicit exit option
  nvim_configs+=("Quit")
  # Use fzf to select
  local choice
  choice="$(printf "%s\n" "${nvim_configs[@]}" | fzf --prompt="Neovim Configs > " --height 30% --border --preview "tree -L 2 {}" --exit-0)"
  if [[ -z "$choice" || "$choice" == "Quit" ]]; then
    return
  fi
  # Print the selected config name
  echo "$(basename "$choice")"
}

# Open Neovim with a config selected via fzf
# Adapted from https://michaeluloth.com/neovim-switch-configs/
### neovim()
# This function does not take any parameters
# Depends on _select_nvim_config()
# -- Opens Neovim with the selected config
neovim() {
  local config=$(_select_nvim_config)
  [[ -z $config ]] && echo "No config selected" && return
  export NVIM_APPNAME=$config && \
  case "$config" in
    nvim* )
      nvim "$@"
      ;;
    lvim )
      lvim "$@"
      ;;
    * )
      echo "Unknown config: $config"
      ;;
  esac
}

# Clean nvim
### clean_nvim()
# This function takes no parameters
# -- Clears nvim cache and swap files
clean_nvim() {
  command rm -vrf "$HOME/.config/$NVIM_APPNAME" &&
  command rm -vrf "$HOME/.local/share/$NVIM_APPNAME" &&
  command rm -vrf "$HOME/.local/state/$NVIM_APPNAME" &&
  command rm -vrf "$HOME/.cache/$NVIM_APPNAME" &&
  echo "Done."
}

# yazi shell wrapper
# https://yazi-rs.github.io/docs/quick-start
### y()
# This function does not take any parameters
# -- provides the ability to change the current working directory when exiting Yazi
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  command rm -f -- "$tmp"
}
