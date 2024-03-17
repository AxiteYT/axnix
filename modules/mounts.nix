{ config, lib, pkgs, modulesPath, ... }: {

  fileSystems."/Apollo" = {
    device = "/dev/sda1";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" ];
  };
}
