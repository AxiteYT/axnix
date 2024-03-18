{ pkgs, config, lib ? pkgs.lib, ... }: {

  # Home Manager

  # axite user
  home-manager.users.axite = { config, pkgs, ... }: {

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Home config
    home = {

      # State version
      stateVersion = "24.05";

      # Editor
      sessionVariables = {
        EDITOR = "codium";
      };

      # Packages
      packages = with pkgs;
        [
          brave
          davinci-resolve
          discord
          dolphinEmu
          gh
          gimp
          hunspell
          k4dirstat
          lutris
          neofetch
          nixfmt
          patchelf
          protonup-qt
          putty
          spotify
          unityhub
          vlc
          vscodium
        ];
    };
    # Programs
    programs = {

      # Git
      git = {
        enable = true;
        userName = "axite";
        userEmail = "kylesmthh@gmail.com";
      };

      # OBS
      obs-studio.enable = true;
      obs-studio.package = pkgs.obs-studio;
      obs-studio.plugins =
        map (plugin: pkgs.obs-studio-plugins.${plugin}) [
          "obs-vaapi"
          "obs-vkcapture"
          "obs-gstreamer"
          "wlrobs"
        ];
    };
  };
}
