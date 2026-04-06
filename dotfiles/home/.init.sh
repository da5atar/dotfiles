#!/usr/bin/env bash

# Set Dropbox and Workspace folders
# Dropbox needs to be installed

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
