{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    # Import the QEMU VM module for additional virtualisation options.
    "${modulesPath}/virtualisation/qemu-vm.nix"
  ];

  # Configuration for the QEMU guest agent
  virtualisation.qemu.guestAgent.enable = true;
}
