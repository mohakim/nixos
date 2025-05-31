{
  description = "Balanced NixOS configuration for single user/machine";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, niri, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit niri; };
      modules = [
        # Core system configuration
        ./configuration.nix
        ./hardware.nix

        # Niri module
        niri.nixosModules.niri

        # Home Manager integration
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mohakim = import ./home;
          home-manager.extraSpecialArgs = { inherit niri; };
          home-manager.backupFileExtension = "backup";
        }

        # Inline overlays
        {
          nixpkgs.overlays = [
            niri.overlays.niri
            (final: prev: {
              proton-ge-custom = prev.stdenv.mkDerivation rec {
                pname = "proton-ge-custom";
                version = "GE-Proton9-27";
                src = prev.fetchurl {
                  url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
                  sha256 = "sha256-u9MQi6jc8XPdKmDvTrG40H4Ps8mhBhtbkxDFNVwVGTc=";
                };
                buildCommand = ''
                  mkdir -p $out/proton-ge-custom
                  tar -xzf $src --strip-components=1 -C $out/proton-ge-custom
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
            })
          ];
        }
      ];
    };
  };
}
