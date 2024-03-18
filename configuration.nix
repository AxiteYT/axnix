{ config, pkgs, ... }:

let
  # Ollama hardware acceleration override
  customOllama = pkgs.ollama.override {
    acceleration = "rocm";
  };
in
{
  imports = [ ];

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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Packages installed in system profile
  #TODO: move these to different flakes depending on system
  environment.systemPackages = with pkgs; [
    btop
    cargo
    cifs-utils
    ffmpeg-full
    gamemode
    killall
    lutris
    neofetch
    neovim
    nixpkgs-fmt
    ntfs3g
    customOllama
    patchelf
    powershell
    vlc
    wayland-utils
    wine
  ];

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Initial systemState
  system.stateVersion = "24.05";
}
