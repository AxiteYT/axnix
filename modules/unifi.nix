{ stdenv, fetchurl, dpkg }:

stdenv.mkDerivation {
  pname = "unifi-custom";
  version = "8.1.113";

  src = fetchurl {
    url = "https://dl.ui.com/unifi/8.1.113/unifi_sysvinit_all.deb";
    sha256 = "d649e6fa5f0c49bed72aad9621b7a1027cfb96844f8e09dcf91f7cce958a1001";
  };

  nativeBuildInputs = [ dpkg ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p $out
    cp -ar usr/lib/unifi $out
  '';

  meta = with stdenv.lib; {
    homepage = "https://ui.com/";
    description = "Custom UniFi Controller software package";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
