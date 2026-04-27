# Toggle function
# Toggle shell integration for the given command argument
### tg()
tg() {
  if [ "$1" = "" ]; then
    echo "tg: Toggle a shell integration"
    echo "Usage: tg <command>"
    return 1
  fi
  if ! _is_installed "$1"; then
    return 1
  fi
  # check if toggle exists
  if [ ! "$(declare -f _tg_"$1")" ]; then
    echo "Toggle not found for: $1"
    return 1
  fi
  export "$1"_toggled
  _tg_"$1"
}

# Function to list available toggles
### _toggles()
_toggles() {
  export toggles_list=()
  compgen -A function | grep '^_tg_' | sed 's/^_tg_//' | while read -r toggle; do
    toggles_list+=("$toggle")
  done
}

# List toggles
toggles() {
  _toggles && {
    echo "Available toggles:"
    echo "----"
    for toggle in "${toggles_list[@]}"; do
      eval "echo ${toggle}: \${${toggle}_toggled}"
    done
    echo "----"
    echo "Call 'tg <toggle>' to toggle a shell integration"
  }
}

# https://mise.jdx.dev/getting-started.html
### tg_mise()
_tg_mise() {

  local current_state="${mise_toggled:-false}"

  if [ "$current_state" = true ]; then
    echo "Deactivating mise environment..."
    mise deactivate >/dev/null
    unset mise_toggled
    echo "mise: deactivated"
  else
    echo "Activating mise environment..."
    # Run activation command.
    eval "$(mise activate zsh)" # shell specific
    mise_toggled=true
    echo "mise: activated"
  fi
}

# Note: This function is tightly coupled with _activate_py_venv
# mostly because of how I set up my Python workflow
# base is the default virtual environment
_tg_python() {
  local current_state="${python_toggled:-false}"

  if [ "$current_state" = true ]; then
    if [ ! -n "$VIRTUAL_ENV" ]; then
      unset python_toggled
      echo "No Python environment is active"
    else
      # calling with nondestructive to leave the reference active
      # helps with proper deactivation when reloading the shell
      echo "Deactivating ${VIRTUAL_ENV} environment..."
      deactivate nondestructive
      unset python_toggled
      echo "deactivated"
    fi
  else
    if [ ! -n "$VIRTUAL_ENV" ]; then
      echo "Activating Python environment..."
      _activate_py_venv "${VENV_PATH}"
      python_toggled=true
      echo "${VIRTUAL_ENV}: activated"
    else
      echo "${VIRTUAL_ENV} is already active"
    fi
  fi
}
