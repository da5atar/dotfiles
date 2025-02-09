#!/bin/bash
# shellcheck disable=SC1091

unameOut="$(uname -s)"
case "${unameOut}" in
Linux*) MACHINE=Linux ;;
Darwin*) MACHINE=Mac ;;
CYGWIN*) MACHINE=Cygwin ;;
MINGW*) MACHINE=MinGw ;;
*) MACHINE="UNKNOWN:${unameOut}" ;;
esac

if [[ "${MACHINE}" == "Linux" ]]; then
  source shared/setup.sh
elif [[ "${MACHINE}" == "Mac" ]]; then
  source mac/setup.sh
fi
