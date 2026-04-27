#!/usr/bin/env bash

### _activate_py_venv - activate a Python virtual environment
# Usage: _activate_py_venv <path-to-virtual-env>
_activate_py_venv() {
  if [ $# -ne 1 ]; then
    echo "Usage: $0 <path-to-virtual-env>" >&2
    return 1
  fi

  VENV_PATH="$1"

  # Validate that the path exists and is a directory
  if [ ! -d "$VENV_PATH" ]; then
    echo "Error: Virtual environment at '$VENV_PATH' does not exist or is not a directory." >&2
    return 1
  fi

  # Validate that the path is readable
  if [ ! -r "$VENV_PATH/bin/activate" ]; then
    echo "Error: Cannot access activation script at '$VENV_PATH/bin/activate'." >&2
    return 1
  fi

  # If python_toggled is not set, do nothing
  if [ -z ${python_toggled+x} ]; then
    echo "No op: No toggle found"
  else
    # shellcheck disable=SC1091
    source "$VENV_PATH/bin/activate"
  fi
}
