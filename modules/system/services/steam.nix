# Steam configuration for Wayland
{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.services.steam;
in
{
  options.modules.services.steam = {
    enable = mkEnableOption "Enable Steam client with Wayland support";

    gamescope = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable Gamescope";
      };

      capSysNice = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to cap system nice levels for Gamescope";
      };

      session = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable Gamescope session";
      };
    };

    gamemode = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable Gamemode for better performance";
    };

    extraProfile = mkOption {
      type = types.lines;
      default = ''
        # Wayland support
        # export GDK_BACKEND=x11
        # export SDL_VIDEODRIVER=x11
        export QT_QPA_PLATFORM=xcb
        export STEAM_FORCE_DESKTOPUI_SCALING=1
      
        # Hardware acceleration
        export LIBVA_DRIVER_NAME=nvidia
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
      
        # Fix black screen on launch or when alt-tabbing
        export STEAM_DISABLE_MANGOAPP=1
      
        # Fix controllers
        export SDL_GAMECONTROLLERCONFIG_FILE=/etc/steam-controller-config.txt
      '';
      description = "Additional environment variables for Steam";
    };
  };

  config = mkIf cfg.enable {
    # Configure Steam to work properly with Wayland
    programs = {
      gamescope = mkIf cfg.gamescope.enable {
        enable = true;
        capSysNice = cfg.gamescope.capSysNice;
      };

      steam = {
        enable = true;
        gamescopeSession.enable = cfg.gamescope.session;
        package = pkgs.steam.override {
          extraProfile = cfg.extraProfile;
        };
      };

      gamemode.enable = cfg.gamemode;
    };

    # Create an empty controller config file to avoid SDL warnings
    environment.etc."steam-controller-config.txt".text = "";

    # Install additional dependencies
    environment.systemPackages = with pkgs; [
      gamemode
    ];
  };
}
