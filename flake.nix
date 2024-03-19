{
  description = "The Axnix flake configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # Home-Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        axnix = lib.nixosSystem
          {
            system = "x86_64-linux";
            modules = [
              # Configuration
              ./configuration.nix

              # Host
              ./hosts/axnix.nix

              # Hardware config
              ./hosts/axnix/amd.nix
              ./hosts/axnix/bootloader.nix
              ./hosts/axnix/hardware-configuration.nix
              ./hosts/axnix/mounts.nix
              ./hosts/axnix/sound.nix

              # Home Manager
              ./home/default.nix
              home-manager.nixosModules.home-manager

              # Modules
              #./modules/ollama.nix
            ];
          };
        jeli = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            # Configuration
            ./configuration.nix

            # Host
            ./hosts/jeli.nix

            # Hardware config
            ./hosts/jeli/bootloader.nix
            ./hardware/qemu.nix

            # Home Manager
            home-manager.nixosModules.home-manager

            # Modules
            ./modules/unifi.nix
          ];
        };
      };
    };
}
