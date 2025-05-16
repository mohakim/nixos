# WhatsApp for Linux configuration module
{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.custom.desktop.whatsapp;
in
{
  options.custom.desktop.whatsapp = {
    enable = mkEnableOption "Enable WhatsApp for Linux configuration";

    package = mkOption {
      type = types.package;
      default = pkgs.whatsapp-for-linux;
      description = "The WhatsApp for Linux package to use";
    };

    darkTheme = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to use dark theme";
    };

    showHeaderBar = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to show the header bar";
    };

    allowPermissions = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to allow web permissions";
    };

    startInTray = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to start minimized in tray";
    };
  };

  config = mkIf cfg.enable {
    # Install package
    home.packages = [ cfg.package ];

    # Create the configuration using home.file
    home.file.".config/wasistlos/settings.conf".source =
      (pkgs.formats.ini { }).generate "whatsapp-settings" {
        web = {
          allow-permissions = cfg.allowPermissions;
          hw-accel = 1;
          min-font-size = 0;
        };

        general = {
          close-to-tray = false;
          start-in-tray = cfg.startInTray;
          start-minimized = cfg.startInTray;
          header-bar = cfg.showHeaderBar;
          zoom-level = 1;
          notification-sounds = true;
        };

        appearance = {
          prefer-dark-theme = cfg.darkTheme;
        };
      };
  };
}
