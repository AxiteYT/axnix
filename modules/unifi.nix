{ lib, pkgs, ... }:
let
  # Define an overlay that adds the custom UniFi package to pkgs
  customUnifiOverlay = self: super: {
    unifi-custom = super.stdenv.mkDerivation {
      pname = "unifi-custom";
      version = "8.1.113";
      src = super.fetchurl {
        url = "https://dl.ui.com/unifi/8.1.113/unifi_sysvinit_all.deb";
        sha256 = "d649e6fa5f0c49bed72aad9621b7a1027cfb96844f8e09dcf91f7cce958a1001";
      };
      nativeBuildInputs = [ super.dpkg ];
      unpackPhase = "dpkg-deb -x $src .";
      installPhase = ''
        mkdir -p $out
        cp -ar usr/lib/unifi $out
      '';
      meta = with super.lib; {
        homepage = "https://ui.com/";
        description = "Custom UniFi Controller";
        license = licenses.unfree;
        platforms = platforms.linux;
      };
    };
  };

  # Apply the overlay to pkgs
  customPkgs = import nixpkgs {
    overlays = [ customUnifiOverlay ];
    system = builtins.currentSystem;
  };
in
{
  # Use the custom pkgs which includes the `unifi-custom` package
  services.unifi = {
    enable = true;
    package = customPkgs.unifi-custom;
  };
}
