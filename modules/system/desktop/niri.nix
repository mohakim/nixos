# System-wide Niri configuration
{ config, pkgs, lib, niri, username, ... }:

with lib;
let
  cfg = config.modules.desktop.niri;
in
{
  options.modules.desktop.niri = {
    enable = mkEnableOption "Enable Niri";
    package = mkOption {
      type = types.package;
      default = pkgs.niri-stable;
      description = "The Niri package to use";
    };
  };
  config = {
    # Install niri packages
    nixpkgs.overlays = [ niri.overlays.niri ];

    programs.niri = {
      enable = true;
      package = pkgs.niri-stable;
    };

    environment.systemPackages = with pkgs; [
      wl-gammarelay-rs
      # xwayland-satellite
      swww
    ];
  };

}
