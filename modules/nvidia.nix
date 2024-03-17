{ config, lib, pkgs, modulesPath, ... }: {

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Fix screentearing (and force composition)
    forceFullCompositionPipeline = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement = {
      enable = false;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      finegrained = false;
    };
    # Disable use of open-source drivers (they kinda suck (atm))
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Specify GPU Channel
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
}
