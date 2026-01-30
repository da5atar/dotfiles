# Installation Instructions

## Setup

- Run `./setup.sh`

What this does:

1. On MacOS:
    a. Installs Homebrew
    b. Installs binaries and apps with Homebrew (see [brew.sh](setup/brew.sh) for a list of installed items)

   On Linux (Debian based):
    a. Updates apt repositories
    b. Installs binaries and apps with apt-get (see [apt.sh](setup/apt.sh) for a list of installed items)

2. Sets npm permissions and installs npm clis (see [npm.sh](setup/npm.sh))

3. Runs `./setup/install-zsh.sh`
    a. Installs ZSH
    b. Installs Oh my ZSH
    c. Installs Oh my ZSH plugins

4. Creates symlinks for dotfiles

Open a new shell to see the changes.

## Optional

- Run `./setup/clone-repos.sh`

What this does:

1. Clone repositories I use. (See [clone-repos.sh](setup/clone-repos.sh) for a list of repositories cloned)
