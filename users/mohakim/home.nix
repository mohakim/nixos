# Home Manager standalone configuration for mohakim
{ config, pkgs, lib, username, overlays, niri, ... }:

{
  imports = [
    # Import profile
    ./profiles/default.nix


    # Import features
    ./features/cli/default.nix
    ./features/desktop/default.nix
  ];

  # Basic home-manager settings
  home.username = username;
  home.homeDirectory = "/home/${username}";

  # Match with your NixOS version
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  # Home Manager configuration specific to standalone use
  # These settings are not needed when using home-manager as a NixOS module
  nixpkgs.config = {
    allowUnfree = true;
    # Add any other nixpkgs config options here
  };

  nixpkgs.overlays = overlays;
}
