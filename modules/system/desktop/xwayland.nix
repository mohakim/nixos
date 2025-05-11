# XWayland support for Niri using xwayland-satellite
{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.desktop.xwayland;
in
{
  options.modules.desktop.xwayland = {
    enable = mkEnableOption "Enable XWayland support with xwayland-satellite";

    clipboardIntegration = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install clipboard utilities for X11/Wayland integration";
    };

    additionalPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Additional X11-related packages to install";
    };
  };

  config = mkIf cfg.enable {
    # Install xwayland-satellite
    environment.systemPackages = with pkgs; [
      # xwayland-satellite
    ] ++ cfg.additionalPackages;

    # Make the DISPLAY variable available to the user environment
    environment.sessionVariables = {
      "DISPLAY" = ":0";
    };
  };
}
