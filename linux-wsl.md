# Windows installation instructions

## Enable Windows Subsystem for Linux (WSL)

Follow instructions from [this blog post](https://learn.microsoft.com/en-us/windows/wsl/install) to enable WSL.

~~Note: This repository is configured for Ubuntu 18.04. If you install a different version, you might need to download a different version for MongoDB in [`apt.sh`](windows/apt.sh). ~~

## Quickly Get Set Up with These Dotfiles

I currently use Ubuntu 20.04 LTS inside of WSL 2 but these dotfiles work on native
Linux too since it's just configuration files. But to help anyone get set up
quicker, here's a few copy / paste'able commands that you can use to install
most of the tools I use on the Linux side of things.

These steps work on Ubuntu 20.04 but it should work on any Debian based distro
too. Just be mindful of maybe needing to enable backports on Debian Buster for
ensuring you get things like tmux version 3.0+.

By the way I would make an effort to read everything before copy / pasting
these commands into a terminal just so you know what's getting installed. You
may want to modify some of these things, such as version numbers.

## Run `setup.sh`

What this does:

1. Updates apt and binaries. (See [`apt.sh`](linux/apt.sh))
2. Installs binaries and apps with `snap` and `flatpak` (see [snap.sh](linux/snap.sh) and [flatpak.sh](linux/flatpak.sh) for a list of installed items)
3. Sets npm permissions
4. Installs npm clis (see [npm.sh](shared/npm.sh) for a list of installed clis)
5. Create symlinks for dotfiles

## Run ./install-zsh.sh

What this does:

1. Installs ZSH
2. Installs Oh my ZSH
3. Installs Oh my ZSH plugins

Open a new shell too see the changes.

## Run ./shared/clone-repos.sh

What this does:

1. Clone repositories I use. (See [clone-repos.sh](shared/clone-repos.sh) for a list of repositories cloned)
