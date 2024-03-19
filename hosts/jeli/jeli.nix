{ nixpkgs, pkgs, ... }: {
  # Networking
  networking = {
    #Hostname
    hostName = "jeli";

    # Gateway
    defaultGateway = "192.168.1.1";
    nameservers = [ "192.168.1.1" ];

    # Interface
    interfaces = {
      enp6s18.ipv4.addresses = [{
        address = "192.168.1.8";
        prefixLength = 24;
      }];
    };
  };

  # Define user account.
  users.users.jeli = {
    isNormalUser = true;
    description = "Jeli";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # System Packages
  environment.systemPackages = with pkgs; [
    git
    neofetch
    nixpkgs-fmt
    tree
  ];
}
