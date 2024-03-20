{ nixpkgs, pkgs, ... }: {
  # Networking
  networking = {
    #Hostname
    hostName = "besta";

    # Gateway
    defaultGateway = "192.168.1.1";
    nameservers = [ "192.168.1.1" ];

    # Interface
    interfaces = {
      enp6s18.ipv4.addresses = [{
        address = "192.168.1.86";
        prefixLength = 24;
      }];
    };
  };

  # Define user account.
  users.users.besta = {
    isNormalUser = true;
    description = "besta";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    gh
    git
    neofetch
    nixpkgs-fmt
    tree
  ];
}
