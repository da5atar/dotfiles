#!/usr/bin/env bash

# exports

export PYTHON_PROJECT_DIR=$DEV_WORKSPACE"/Python/"

# Current Dev Project folder
export CURRENT_DEV_PROJECT=$DEV_WORKSPACE"/Current_Project/"

# function to backup current dev project
### save_dev_project()
# Note:Backup directory must exist and be empty!
save_dev_project() {
  local BACKUP=$1 || $PWD

  if (isEmpty "$BACKUP"); then
    echo "Backing up"
    dsync "$CURRENT_DEV_PROJECT" "$BACKUP" || {
      echo "Failure to backup to $BACKUP"
      exit
    }
    echo "Backup done!"
  else
    echo "Destination folder not empty"
    echo "Cannot backup folder on non empty folder"
  fi
}

workon_dev_project() {
  mkdir "$CURRENT_DEV_PROJECT$(here)"
  cp -R "$PWD"/ "$CURRENT_DEV_PROJECT$(here)"
  workspace=$CURRENT_DEV_PROJECT"$(here)"
  echo "Copied the content of dev project to ${workspace}"
  cd "$workspace" || {
    echo "Failure to switch to $workspace"
    exit
  }
  echo "Switched to $(workspace) folder"
}
