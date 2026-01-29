#!/usr/bin/env bash

unameOut="$(uname -s)"
case "${unameOut}" in
Linux*) MACHINE=Linux ;;
Darwin*) MACHINE=Mac ;;
CYGWIN*) MACHINE=Cygwin ;;
MINGW*) MACHINE=MinGw ;;
*) MACHINE="UNKNOWN:${unameOut}" ;;
esac
export MACHINE

# Set Dropbox and Dev Workspace folders
# Dropbox needs to be installed
export HOSTNAME
HOSTNAME="$(hostname)"

export WORKSPACE
WORKSPACE=${HOME} # Default
# override for Parallels' VMs:
# WORKSPACE=/media/psf # change as needed

# Dev Workspace folder for dev envs
export DEV_WORKSPACE=${WORKSPACE}"/Dev"

# Dropbox folder
export DROPBOX_FOLDER
# On Mac Dropbox utilizes updated Apple File Provider API on Mac 12.5+
if [[ "${MACHINE}" == "Mac" ]]; then
    DROPBOX_FOLDER=${HOME}"/Library/CloudStorage/Dropbox"
else
    DROPBOX_FOLDER=${HOME}"/Dropbox" # Default
fi

# Dev projects backup folder
export DEV_PROJECTS
DEV_PROJECTS=${DEV_WORKSPACE}"/Projects"

# GitHub working folder
export GITHUB_FOLDER
GITHUB_FOLDER=${DEV_PROJECTS}"/GitHub"

# These dotfiles
export PROJECT_ROOT
PROJECT_ROOT=${GITHUB_FOLDER}"/dotfiles"
