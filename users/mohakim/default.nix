# Home Manager configuration for mohakim (NixOS module version)
{ config, pkgs, lib, niri, username, ... }:

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

  # This configuration is specifically for the NixOS module integration
  # For standalone configuration, see home.nix
}
