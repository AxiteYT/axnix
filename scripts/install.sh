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

#TODO: Uncomment this if you want to install bootloader manually
: <<'END'
# Bootloader
echo ######################################################################
echo ""
echo Ignore the prior error messages, installing bootloader manually now...
echo ""
echo ######################################################################

for i in dev proc sys; do mount --rbind /$i /mnt/$i; done
NIXOS_INSTALL_BOOTLOADER=1 chroot /mnt \
  /nix/var/nix/profiles/system/bin/switch-to-configuration boot
END

# Explain password setting
echo ######################################################################
echo "Please set the root password by running the following commands:"
echo ""

echo "nixos-enter --root /mnt"
echo "passwd ${desiredFlake}"
echo "exit"

echo ######################################################################

# Reboot
#TODO: Reboot
