{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/amd.nix
    ./modules/mounts.nix
    <home-manager/nixos>
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  # Define hostname
  networking.hostName = "axnix";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_AU.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_AU.UTF-8";
      LC_IDENTIFICATION = "en_AU.UTF-8";
      LC_MEASUREMENT = "en_AU.UTF-8";
      LC_MONETARY = "en_AU.UTF-8";
      LC_NAME = "en_AU.UTF-8";
      LC_NUMERIC = "en_AU.UTF-8";
      LC_PAPER = "en_AU.UTF-8";
      LC_TELEPHONE = "en_AU.UTF-8";
      LC_TIME = "en_AU.UTF-8";
    };
  };

  # Service configuration
  services = {
    flatpak.enable = true;

    # Configure keymap in X11
    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      xkb = {
        layout = "au";
        variant = "";
      };

      # Enable the KDE Plasma Desktop environment
      displayManager = {
        sddm = {
          enable = true;
          wayland.enable = true;
        };
        defaultSession = "plasma";
      };
    };

    # Enable KDE Plasma
    desktopManager.plasma6.enable = true;

    # Enable CUPS to print documents.
    printing.enable = true;

  };

  # Theming
  qt = {
    enable = true;
    style = "adwaita-dark";
  };

  programs.dconf.enable = true;

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      (nerdfonts.override { fonts = [ "Meslo" ]; })
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Meslo LG M Regular Nerd Font Complete Mono" ];
        serif = [ "Noto Serif" "Source Han Serif" ];
        sansSerif = [ "Noto Sans" "Source Han Sans" ];
      };
    };
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define user account.
  users.users.axite = {
    isNormalUser = true;
    description = "Kyle Smith";
    extraGroups = [ "networkmanager" "wheel" "flatpak" ];

    # Packages
    packages = with pkgs; [
      brave
      dolphinEmu
      spotify
      discord
      gimp
      libreoffice-qt
      hunspell
      hunspellDicts.en_AU
      hunspellDicts.en_US
    ];
  };

  # Home Manager
  home-manager.users.axite = { config, pkgs, ... }: {

    home = { stateVersion = "24.05"; };

    # Packages
    home.packages = with pkgs;
      [

      ];

    # OBS
    programs.obs-studio.enable = true;
    programs.obs-studio.package = pkgs.obs-studio;
    programs.obs-studio.plugins =
      map (plugin: pkgs.obs-studio-plugins.${plugin}) [
        "obs-vaapi"
        "obs-vkcapture"
        "obs-gstreamer"
        "wlrobs"
      ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Packages installed in system profile
  environment.systemPackages = with pkgs; [
    neovim
    cifs-utils
    ntfs3g
    btop
    davinci-resolve
    nixfmt
    putty
    neofetch
    ffmpeg
    git
    gh
    k4dirstat
    patchelf
    lutris
    killall
    vlc
    vscodium
    wayland-utils
  ];

  # Enable wayland for Chromium/Electron based applications
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  system.stateVersion = "24.05"; # Did you read the comment?
}
