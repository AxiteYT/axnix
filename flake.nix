{
  description = "The Axnix flake configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # Disko
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home-Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, disko, ... }:
    let
      lib = nixpkgs.lib;
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      nixosConfigurations = {

        ISO = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            # Installation CD
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            ({ pkgs, ... }: {
              systemd.services.sshd.wantedBy = nixpkgs.lib.mkForce [ "multi-user.target" ];

              # Add SSH key(s)
              users.users.root.openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINMXEwWst3Kkag14hG+nCtiRX8KHcn6w/rUeZC5Ww7RU axite@axitemedia.com"
              ];
              environment.systemPackages = [ ];
            })
          ];
        };

        axnix = lib.nixosSystem
          {
            system = "x86_64-linux";
            modules = [
              # Configuration
              ./configuration.nix

              # Host
              ./hosts/axnix/axnix.nix

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
              ./modules/ollama.nix

              # Custom NordVPN
              #./modules/nordvpn/default.nix
            ];
          };
        jeli = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            # Configuration
            ./configuration.nix

            # Host
            ./hosts/jeli/jeli.nix

            # Hardware config
            ./hosts/jeli/bootloader.nix
            ./hosts/jeli/hardware-configuration.nix
            ./hardware/qemu.nix

            # Home Manager
            home-manager.nixosModules.home-manager

            # Modules
            #./modules/unifi.nix
          ];
        };
        besta = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            # Configuration
            ./configuration.nix

            # Host
            ./hosts/besta/besta.nix

            # Disko
            disko.nixosModules.disko
            ./hosts/besta/disko.nix

            # Hardware config
            ./hosts/besta/bootloader.nix
            ./hosts/besta/hardware-configuration.nix
            ./hardware/qemu.nix

            # Home Manager
            home-manager.nixosModules.home-manager

            # Modules
          ];
        };
      };
    };
}
