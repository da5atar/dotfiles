#!/bin/bash 

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*)    MACHINE=Cygwin;;
    MINGW*)     MACHINE=MinGw;;
    *)          MACHINE="UNKNOWN:${unameOut}"
esac

if [[ "$MACHINE" == "Linux" ]]
  then 
    source shared/setup.sh
    source linux/linuxbrew.sh
elif [[ "$MACHINE" == "Mac" ]]
  then 
    source mac/setup.sh
fi
