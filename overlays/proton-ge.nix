final: prev: {
  proton-ge-custom = prev.stdenv.mkDerivation rec {
    pname = "proton-ge-custom";
    version = "GE-Proton9-27"; # Update this as needed

    src = prev.fetchurl {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      sha256 = "sha256-u9MQi6jc8XPdKmDvTrG40H4Ps8mhBhtbkxDFNVwVGTc=";
    };

    buildCommand = ''
      mkdir -p $out/proton-ge-custom
      tar -xzf $src --strip-components=1 -C $out/proton-ge-custom
      
      # Create the compatibility tools directory structure
      mkdir -p $out/share/steam/compatibilitytools.d
      ln -s $out/proton-ge-custom $out/share/steam/compatibilitytools.d/${version}
    '';

    meta = with prev.lib; {
      description = "Compatibility tool for Steam Play based on Wine and additional components";
      homepage = "https://github.com/GloriousEggroll/proton-ge-custom";
      license = licenses.bsd3;
      platforms = platforms.linux;
    };
  };
}
