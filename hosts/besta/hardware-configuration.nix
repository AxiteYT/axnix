{ config, lib, pkgs, modulesPath }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    kernelModules = [
      "kvm-intel"
    ];
    extraModulePackages = [
    ];

    initrd = {
      avaliableKernelModules = [
        "uhci_hcd"
        "ehci_pci"
        "ahci"
        "virtio_pci"
        "virtio_scsi"
        "sd_mod"
        "sr_mod"
      ];
      kernelModules = [
      ];
    };
  };
}
