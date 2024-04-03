{ config, lib, pkgs, ... }: {
  # Bootloader.
  boot.loader = {
    efi = {
      efiSysMountPoint = "/boot/efi";
      canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      #TODO: Add this back if canTouchEfiVariables doesnt work | efiInstallAsRemovable = true;
    };
  };
}
