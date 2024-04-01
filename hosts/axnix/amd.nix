{ config, lib, pkgs, modulesPath, ... }: {
  # Set GPU in kenel
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Set XServer/Wayland to use AMD
  services.xserver.videoDrivers = [ "amdgpu" ];

  # OpenGL configuration
  hardware.opengl = {
    # Enable Driver
    driSupport = true;
    driSupport32Bit = true;

    # Vulkan + OpenCL packages
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      amdvlk
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

  # HIP Libraries override
  systemd.tmpfiles.rules =
    [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];
}
