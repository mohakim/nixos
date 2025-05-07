# System-wide Niri configuration
{ config, pkgs, lib, niri, ... }:

with lib;
let
  cfg = config.modules.desktop.niri;
in
{
  options.modules.desktop.niri = {
    enable = mkEnableOption "Enable Niri window manager";

    package = mkOption {
      type = types.package;
      default = pkgs.niri-stable;
      description = "The Niri package to use (stable or unstable)";
    };

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable Niri auto-start in the display manager";
    };
  };

  config = mkIf cfg.enable {
    # Add the niri overlay to make niri packages available
    nixpkgs.overlays = [ niri.overlays.niri ];

    # Enable Niri window manager
    programs.niri = {
      enable = true;
      package = cfg.package;
    };

    # Configure the display manager to use Niri
    services.greetd = mkIf cfg.autoStart {
      enable = true;
      settings = {
        default_session = {
          command = "niri --session";
          user = "mohakim";
        };
      };
    };

    # Add environment variables for Wayland
    environment.sessionVariables = {
      "NIXOS_OZONE_WL" = "1";
      "MOZ_ENABLE_WAYLAND" = "1";
      "XDG_CURRENT_DESKTOP" = "niri";
    };
  };
}
