{
  description = "The Axnix flake configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

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
              ./hardware/amd.nix
              ./hardware/bootloader.nix
              ./hardware/hardware-configuration.nix
              ./hardware/mounts.nix
              ./hardware/sound.nix

              # Home Manager
              ./home/default.nix
              home-manager.nixosModules.home-manager
            ];
          };
      };
    };
}
