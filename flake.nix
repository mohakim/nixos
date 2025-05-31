{
  description = "NixOS configuration with modular home-manager integration";

  inputs = {
    # Core dependencies
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Niri window manager
    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";

    # Home Manager for user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, niri, home-manager, ... }:
    let
      system = "x86_64-linux";
      username = "mohakim";

      # Import all overlays from the overlays directory
      # This returns a list of overlay functions
      overlays = import ./overlays ++ [
        niri.overlays.niri
      ];

      # Create a properly overlaid pkgs
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = overlays;
      };

      # Helper function to create system configurations
      mkSystem = { hostname, extraModules ? [ ] }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit nixpkgs niri home-manager username overlays;
          };
          modules = [
            { nixpkgs.overlays = overlays; }

            # Host-specific configuration
            ./hosts/${hostname}
            # Include common modules
            ./hosts/common/global.nix
            ./hosts/common/users.nix

            # Include Niri module
            niri.nixosModules.niri

            # Add Home Manager as NixOS module
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import ./users/${username}/default.nix;
              home-manager.extraSpecialArgs = {
                inherit niri overlays username;
              };
              home-manager.backupFileExtension = "backup";
            }
          ] ++ extraModules;
        };
    in
    {
      # NixOS system configurations
      nixosConfigurations = {
        # Current machine
        nixos = mkSystem {
          hostname = "nixos";
        };
      };

      # Standalone home-manager configurations
      homeConfigurations = {
        # Current user configuration
        "${username}@nixos" = home-manager.lib.homeManagerConfiguration {
          # Use the overlaid pkgs
          inherit pkgs;

          extraSpecialArgs = {
            inherit niri overlays username;
          };
          modules = [
            ./users/${username}/home.nix
            niri.homeModules.config
          ];
        };
      };

      # Development shell for Nix tools
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixpkgs-fmt
          nil # Nix LSP
          home-manager # For home-manager CLI
        ];
      };
    };
}
