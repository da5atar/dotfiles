# Device installation scripts for Mac and Windows (WSL)
## Quickly Get Set Up with These Dotfiles

This repository was inspired by [Mathias Bynens' dotfiles](https://github.com/mathiasbynens/dotfiles) repository and adapted from [Zell Liew's](https://github.com/zellwk/dotfiles) and from [Nick Janetakis's dotfiles](https://github.com/nickjj/dotfiles.git).
Although I copied many things, I also deleted/updated many things to suit my custom installation. Use this at your own risk!

Here are the installation instructions for Mac and Windows (WSL)

- [Mac instructions](mac.md)
- [Windows (WSL) and Linux instructions](linux-wsl.md)

```sh
# Create your own personal ~/.gitconfig.user file. After copying the file,
# you should edit it to have your name and email address so git can use it.
cp ~/dotfiles/.gitconfig.user ~/.gitconfig.user
```

Optionally confirm that a few things work after closing and re-opening your
terminal:

```sh
# Sanity check to see if you can run some of the tools we installed.
ruby --version
node --version
# ansible --version
# aws --version
# terraform --version

# Check to make sure git is configured with your name, email and custom settings.
git config --list

# If you're using Docker Desktop with WSL 2, these should be accessible too.
docker info
docker-compose --version
```

#### Using WSL 1 or WSL 2?

In addition to the Linux side of things, there's a few config files that I have
in various directories of this dotfiles repo. These have long Windows paths.

It would be expected that you copy those over to your system while replacing
"Mass" with your Windows user name if you want to use those things, such as my Microsoft Terminal `settings.json` file and others.
Some of the paths may also contain unique IDs too, so adjust them as needed on your end.

Some of these configs expect that you have certain programs or tools installed
on Windows.

Pay very close attention to the `c/Users/Mass/.wslconfig` file in the windows folder because it has
values in there that you will very likely need to change before using it.
[This commit message](https://github.com/nickjj/dotfiles/commit/d0f1fc2622204b809cf7fcbb1a82d45b451064c4)
goes into the details.

Also, you should reboot to activate your `/etc/wsl.conf` file (symlinked
earlier). That will be necessary if you want to access your mounted drives at
`/c` or `/d` instead of `/mnt/c` or `/mnt/d`.


Have a suggestion? [Please let me know!](mailto:mass.sow@gmail.com)