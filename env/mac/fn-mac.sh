#!/usr/bin/env bash

# macOS compatible, requires Homebrew for some tools

# Extract various archive types
extract() {
  local file="$1"

  if [[ ! -f "$file" ]]; then
    echo "'$file' is not a valid file" >&2
    return 1
  fi

  case "$file" in
    *.tar.bz2|*.tbz2) tar xjf "$file" ;;
    *.tar.gz|*.tgz)    tar xzf "$file" ;;
    *.bz2)             bunzip2 "$file" ;;
    *.rar)             unrar x "$file" ;;
    *.gz)              gunzip "$file" ;;
    *.tar)             tar xf "$file" ;;
    *.zip)             unzip "$file" ;;
    *.Z)               uncompress "$file" ;;
    *.7z)              7z x "$file" ;;
    *) echo "Cannot extract '$file'" >&2; return 1 ;;
  esac

  return $?
}

# ---- MANPATH ----

# only keep valid man entries on macOS
validate_manpath() {
  local mandir new_manpath=""

  while IFS= read -r mandir; do
    [[ -z $mandir ]] && continue
    # skip homebrew "gnubin/man" entries
    [[ $mandir =~ "gnubin" ]] && continue
    [[ -d $mandir ]] && new_manpath+="${mandir}:"
  done < <(printf '%s' "$(manpath)" | tr ':' '\n')

  MANPATH=${new_manpath%:}
  export MANPATH
}

# View man pages from GNU-installed packages
gnuman() {
  local new_manpath=""
  if command -v manpath &>/dev/null; then
    while IFS= read -r mandir; do
      [[ -z "$mandir" ]] && continue
      # Skip non-homebrew dirs (these are native BSD)
      [[ ! "$mandir" =~ "homebrew" ]] && continue
      [[ -d "$mandir" ]] && new_manpath+="${mandir}:"
    done < <(printf '%s' "$(manpath)" | tr ':' '\n')

    [[ -n "${new_manpath}" ]] && export MANPATH="${new_manpath%:}"

    if command -v batman &>/dev/null; then
      batman
    else
      echo "batman is not installed - use 'brew install bat-extras' or regular 'man' command"
    fi
  fi
}

# View man pages from BSD/native packages (not from Homebrew)
bsdman() {
  local new_manpath=""
  if command -v manpath &>/dev/null; then
    while IFS= read -r mandir; do
      [[ -z "$mandir" ]] && continue
      # Skip Homebrew dirs
      [[ "$mandir" =~ "homebrew" ]] && continue
      [[ -d "$mandir" ]] && new_manpath+="${mandir}:"
    done < <(printf '%s' "$(manpath)" | tr ':' '\n')

    [[ -n "${new_manpath}" ]] && export MANPATH="${new_manpath%:}"

    if command -v batman &>/dev/null; then
      batman
    else
      echo "batman is not installed - use 'brew install bat-extras' or regular 'man' command"
    fi
  fi
}

# View any man page (delegates to batman if available)
man() {
  if command -v batman &>/dev/null; then
    batman "$@"
  elif command -v man &>/dev/null; then
    man "$@"
  else
    echo "Neither batman nor man is available" >&2
    return 1
  fi
}
