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
    cascade = {
      url = "github:cascadefox/cascade";
      flake = false;
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, niri, home-manager, cascade, lanzaboote, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit niri cascade; };
      modules = [
        # Core system configuration
        ./configuration.nix
        ./hardware.nix
        niri.nixosModules.niri
        lanzaboote.nixosModules.lanzaboote

        # Home Manager integration
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mohakim = import ./home;
          home-manager.extraSpecialArgs = { inherit niri cascade; };
          home-manager.backupFileExtension = "backup";
        }
      ];
    };
  };
}
