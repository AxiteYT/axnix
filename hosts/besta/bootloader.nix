{ config, lib, pkgs, ... }: {
  # Bootloader.
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    efiInstallAsRemovable = true;
    efiSysMountPoint = "/boot/efi";
  };
}
