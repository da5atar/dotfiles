#!/usr/bin/env bash

#--- Git

# Determine git branch.
parse_git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# gitignore()
# Retrieves .gitignore content from https://www.toptal.com/developers/gitignore and writes it to .gitignore
# Usage: gitignore  [<software>]
# Example: gitignore python,django > .gitignore
# Example: gi java,python >> .gitignore
function gitignore() { curl -sL https://www.toptal.com/developers/gitignore/api/"$*"; }

# Provides completion for zsh https://docs.gitignore.io/use/advanced-command-line

_gitignoreio_get_command_list() {
    curl -sL https://www.toptal.com/developers/gitignore/api/list | tr "," "\n"
}

_gitignoreio() {
    compset -P '*,'
    compadd -S '' "$(_gitignoreio_get_command_list)"
}

compdef _gitignoreio gi
