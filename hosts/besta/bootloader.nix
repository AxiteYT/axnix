{ config, lib, pkgs, ... }: {
  # Bootloader.
  boot.loader = {
    efi.efiSysMountPoint = "/boot/efi";
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };
}
