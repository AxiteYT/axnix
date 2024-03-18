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

    # Nixified.ai
    nixifiedai.url = "github:nixified-ai/flake";
  };

  outputs = { self, nixpkgs, home-manager, nixifiedai, ... }:
    let
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations = {
        axnix = lib.nixosSystem
          {
            system = "x86_64-linux";
            specialArgs = { inherit nixifiedai; };
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

              # Modules
              ./modules/nixified-ai.nix
            ];
          };
      };
    };
}
