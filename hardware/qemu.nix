{ config, lib, pkgs, modulesPath, ... }: {
  virtualisation.qemu.guestAgent.enable = true;
}
