#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Re-running the script with root privileges..."
  sudo bash "$0" "$@"
  exit $?
fi

# Pull the repo
cd /tmp
nix-env -iA nixos.git
git clone https://github.com/axiteyt/axnix
cd ./axnix

# Update flake
nix flake update

# Prompt user for flake
echo 'Displaying flakes'
nix flake show
echo 'Which flake would you like to pick?'
read desiredFlake

# TODO: Check if this works # Format disks using disko
nix run github:nix-community/disko -- --mode zap_create_mount --flake .#${desiredFlake} --arg disks '[ "/dev/sda" ]'