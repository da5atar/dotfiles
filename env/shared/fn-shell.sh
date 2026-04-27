#!/usr/bin/env bash

# ---- Aliases ----

# --------------------------------------------------------------------
#   find_alias <alias_name>
#
#   Prints the definition(s) of <alias_name> as reported by a
#   “zsh -ixc” run.  Useful when you have many startup files and
#   want to know exactly where an alias comes from.
#
#   Example:
#       find_alias ls
# --------------------------------------------------------------------
find_alias() {
  local alias_name="${1:-}"
  if [[ -z "$alias_name" ]]; then
    echo "Usage: find_alias <alias_name>" >&2
    return 1
  fi

  # Run zsh in interactive mode, trace commands, and capture stderr.
  # The -x flag causes zsh to echo every command it executes, including
  # the alias definitions it reads from your startup files.
  zsh -ixc ":" 2>&1 | grep "alias '$alias_name"
  return 0
}

# ---- Commands ----

# Find whether a command is a function, builtin, or alias
# Usage: cmd_info <command>
# Arguments:
#   <command> - the command to check
### cmd_info()
cmd_info() {
  if [[ -z "$1" ]]; then
    echo "Usage: cmd_info <command>"
    return 1
  fi
  local cmd=$(type -w "$1")
  echo "$cmd"
  case "$cmd" in
  *alias) which "$1" && find_alias "$1" ;;
  *command) type -p "$1" ;;
  *function) type "$1" && type -f "$1" ;;
  *builtin | *reserved) type -a "$1" ;;
  esac
  return 0
}

# Normalize `open` across Linux, macOS, and Windows.
# This is needed to make the `o` function (see fn-dirs.sh) cross-platform.
if [[ ! "$(uname -s)" = 'Darwin' ]]; then
  alias open='xdg-open'
fi

# ---- File Descriptors ----

# fdsummary – print the top N processes by open‑file‑descriptor count
#
# Usage:
#   fdsummary                # use current user’s permissions (no sudo)
#   fdsummary --sudo          # run lsof with sudo (root) for a full list
#   fdsummary -n 100         # show the top 100 processes instead of 50
#
fdsummary() {
  local use_sudo=no # flag: do we need sudo?
  local limit=50    # default top‑N

  # ----- parse options ---------------------------------------------
  while [[ $# -gt 0 ]]; do
    case "$1" in
    --sudo)
      use_sudo=yes
      shift
      ;;
    -n | --limit)
      shift
      limit="${1:-$limit}"
      shift
      ;;
    *)
      echo "fdsummary: unknown option: $1" >&2
      return 1
      ;;
    esac
  done

  # ----- build the lsof command ------------------------------------
  local lsof_cmd="lsof -nP"
  [[ $use_sudo == yes ]] && lsof_cmd="sudo $lsof_cmd"

  # ----- run lsof, count descriptors per PID, sort, truncate -------
  eval "$lsof_cmd" |
    awk 'NR>1{count[$2]++; cmd[$2]=$1} \
             END{for(p in count) printf "%6d %6d %s\n", count[p], p, cmd[p] | "sort -nr"}' |
    head -n "$limit"
}

# ---- FPATH ----

# function to echo $FPATH one entry per line
### no_dupes_fpath()
show_fpath() {
  awk -v RS=: '{print}' <<<"$FPATH"
}

# ---- Logout ----

# Usage: deactivate running shell processes for graceful exit
### x_it()
x_it() {
  # Gracefully exit any running shell processes
  if jobs &>/dev/null; then
    kill -TERM "$(jobs -p)" &>/dev/null
  fi
}

# ---- PATH ----

# function to remove duplicates in and echo $PATH
# Note: Inspired from https://www.linuxjournal.com/content/removing-duplicate-path-entries

### no_dupes_path()
_no_dupes_path() {
  local no_dupes_path
  no_dupes_path=$(echo "$PATH" | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')
  echo "$no_dupes_path"
}

# function to echo $PATH one entry per line
### no_dupes_path()
show_path() {
  awk -v RS=: '{print}' <<<"$PATH"
}

# function to set $PATH with no dupes and echo one entry per line
### no_dupes_path()
set_no_dupes_path() {
  PATH=$(_no_dupes_path)
  export PATH
  show_path
}

# ---- Reload shell ----

# Usage: reload
### reload()
reload() {
  command -v deactivate >/dev/null && deactivate nondesctructive
  x_it
  exec "${SHELL}" -l
}
