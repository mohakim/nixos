# wl-gammarelay-rs configuration module
{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.custom.desktop.wl-gammarelay;
in
{
  options.custom.desktop.wl-gammarelay = {
    enable = mkEnableOption "Enable wl-gammarelay-rs for blue light filtering";

    defaultBrightness = mkOption {
      type = types.float;
      default = 1.0;
      description = "Default screen brightness (0.0-1.0)";
    };

    defaultTemperature = mkOption {
      type = types.int;
      default = 6500;
      description = "Default color temperature in Kelvin";
    };

    nightTemperature = mkOption {
      type = types.int;
      default = 4000;
      description = "Night color temperature in Kelvin";
    };

    autoNightMode = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to automatically switch to night mode";
    };

    nightModeTimeRange = mkOption {
      type = types.attrsOf types.str;
      default = {
        start = "20:00";
        end = "06:00";
      };
      description = "Time range for night mode";
    };
  };

  config = mkIf cfg.enable {
    # Enable the wl-gammarelay-rs service
    systemd.user.services.wl-gammarelay = {
      Unit = {
        Description = "DBus interface to control display temperature and brightness under wayland";
        PartOf = "graphical-session.target";
        After = "graphical-session.target";
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };
      Service = {
        Type = "dbus";
        BusName = "rs.wl-gammarelay";
        ExecStart = "${pkgs.wl-gammarelay-rs}/bin/wl-gammarelay-rs run";
        Environment = mkIf (cfg.defaultBrightness != 1.0 || cfg.defaultTemperature != 6500)
          "WLR_GAMMA_REL_BRIGHTNESS=${toString cfg.defaultBrightness} WLR_GAMMA_REL_TEMPERATURE=${toString cfg.defaultTemperature}";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    # Automatic night mode service
    systemd.user.services.wl-gammarelay-night-mode = mkIf cfg.autoNightMode {
      Unit = {
        Description = "Automatic night mode for wl-gammarelay";
        After = "wl-gammarelay.service";
        Requires = "wl-gammarelay.service";
      };
      Service = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "wl-gammarelay-night-mode" ''
          #!/bin/sh
          current_time=$(date +%H:%M)
          night_start="${cfg.nightModeTimeRange.start}"
          night_end="${cfg.nightModeTimeRange.end}"
          
          is_night() {
            if [ "$night_start" \< "$night_end" ]; then
              # Simple case: night is within the same day
              [ "$current_time" \>= "$night_start" ] && [ "$current_time" \< "$night_end" ]
            else
              # Complex case: night spans midnight
              [ "$current_time" \>= "$night_start" ] || [ "$current_time" \< "$night_end" ]
            fi
          }
          
          if is_night; then
            busctl --user call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n ${toString cfg.nightTemperature}
          else
            busctl --user call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n ${toString cfg.defaultTemperature}
          fi
        '';
      };
    };

    # Add timer for automatic night mode
    systemd.user.timers.wl-gammarelay-night-mode = mkIf cfg.autoNightMode {
      Unit = {
        Description = "Run night mode check periodically";
      };
      Timer = {
        OnBootSec = "1min";
        OnUnitActiveSec = "10min";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
  };
}
