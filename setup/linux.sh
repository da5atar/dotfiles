#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2312

# Update and upgrade apt
sudo apt update && sudo apt upgrade -y

# Install binaries via apt
echo "===================="
echo "Running apt.sh"
printf "====================\n"

source apt.sh

echo "===================="
echo "Done running apt.sh"
printf "====================\n"
