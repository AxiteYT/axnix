{ stdenv
, lib
, fetchurl
, openvpn
, libxml2
, autoPatchelfHook
, dpkg
, libidn2
}:

let
  mirror = "https://repo.nordvpn.com/deb/nordvpn/debian/pool/main";
in
stdenv.mkDerivation rec {
  pname = "nordvpn";
  version = "3.17.2";

  src = fetchurl {
    url = "${mirror}/${pname}_${version}_amd64.deb";
    sha256 = "sha256-rj1QuCOztgVmReCn24HIEDAyLR7GlsUDJK0GZl+ERXM=";
  };

  nativeBuildInputs = [ libidn2 libxml2 autoPatchelfHook dpkg ];

  unpackPhase = ''
    dpkg -x $src unpacked
  '';

  installPhase = ''
    mkdir -p $out/
    sed -i 's;ExecStart=.*;;g' unpacked/usr/lib/systemd/system/nordvpnd.service
    cp -r unpacked/* $out/
    mv $out/usr/* $out/
    mv $out/sbin/nordvpnd $out/bin/
    rm -r $out/sbin
    # rm $out/var/lib/nordvpn/openvpn
    # ln -s ${openvpn}/bin/openvpn $out/var/lib/nordvpn/openvpn
  '';

  meta = with lib; {
    homepage = "https://nordvpn.com/";
    downloadPage = "https://nordvpn.com/download/";
    description = ''
      NordVPN: The best online VPN service for speed and security
      NordVPN protects your privacy online and
      lets access media content without regional restrictions.
      Strong encryption and no-log policy
      with 5000+ servers in 60+ countries.'';
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ juliosueiras ];
  };
}
