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
nix --extra-experimental-features "nix-command flakes" flake update

# Prompt user for flake
echo 'Displaying flakes'
nix --extra-experimental-features "nix-command flakes" flake show
echo 'Which flake would you like to pick?'
read desiredFlake

# Format disks using disko
nix \
  --experimental-features "nix-command flakes" \
  run github:nix-community/disko -- \
  --mode disko /tmp/axnix/hosts/${desiredFlake}/disko.nix

# Install NixOS
nixos-install --flake .#${desiredFlake} --root /mnt --no-root-password

# Prompt for password
nixos-enter --root /mnt # Enter freshly installed OS
passwd ${desiredFlake}

# Reboot
#TODO: Reboot
