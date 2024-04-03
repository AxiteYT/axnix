{ config, lib, pkgs, ... }: {
  # Bootloader.
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
}
