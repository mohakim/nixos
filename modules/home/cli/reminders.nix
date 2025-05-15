# Prayer time reminders module (KISS approach)
{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.custom.cli.reminders;

  # This is the ONLY script - just for fetching
  fetchScript = pkgs.writeShellScript "fetch-prayer-times" ''
    #!/usr/bin/env bash
    # Script that ONLY fetches prayer times
    
    # Parameters passed from Nix
    CITY="$1"
    COUNTRY="$2"
    METHOD="$3"
    OUTPUT_FILE="$4"
    
    # Create directory if needed
    mkdir -p "$(dirname "$OUTPUT_FILE")"
    
    # Simple URL encoding for spaces
    CITY_ENCODED=''${CITY// /%20}
    COUNTRY_ENCODED=''${COUNTRY// /%20}
    
    # Get current date
    DATE=$(date +"%d-%m-%Y")
    
    # Fetch prayer times
    ${pkgs.curl}/bin/curl -s "https://api.aladhan.com/v1/timingsByCity/$DATE?city=$CITY_ENCODED&country=$COUNTRY_ENCODED&method=$METHOD" > "$OUTPUT_FILE"
  '';

  # Prayer data structure
  prayers = {
    Fajr = cfg.fajrDelay;
    Dhuhr = cfg.dhuhrDelay;
    Asr = cfg.asrDelay;
    Maghrib = cfg.maghribDelay;
    Isha = cfg.ishaDelay;
  };
in
{
  options.custom.cli.reminders = {
    enable = mkEnableOption "Enable prayer time reminders";

    city = mkOption {
      type = types.str;
      default = "Kuala Lumpur";
      description = "City for prayer times calculation";
    };

    country = mkOption {
      type = types.str;
      default = "Malaysia";
      description = "Country for prayer times calculation";
    };

    method = mkOption {
      type = types.int;
      default = 3;
      description = "Method for prayer times calculation (1-15)";
    };

    fajrDelay = mkOption {
      type = types.int;
      default = 15;
      description = "Delay in minutes after Fajr prayer";
    };

    dhuhrDelay = mkOption {
      type = types.int;
      default = 15;
      description = "Delay in minutes after Dhuhr prayer";
    };

    asrDelay = mkOption {
      type = types.int;
      default = 15;
      description = "Delay in minutes after Asr prayer";
    };

    maghribDelay = mkOption {
      type = types.int;
      default = 5;
      description = "Delay in minutes after Maghrib prayer";
    };

    ishaDelay = mkOption {
      type = types.int;
      default = 15;
      description = "Delay in minutes after Isha prayer";
    };

    enableHourlyReminders = mkOption {
      type = types.bool;
      default = true;
      description = "Enable hourly reminders to stand up";
    };
  };

  config = mkIf cfg.enable {
    # Install required packages
    home.packages = with pkgs; [ mpv ];

    # Create all services in ONE definition
    systemd.user.services =
      # Fetch service
      {
        fetch-prayer-times = {
          Unit = {
            Description = "Fetch prayer times for today";
          };
          Service = {
            Type = "oneshot";
            # Pass Nix parameters to the script
            ExecStart = "${fetchScript} '${cfg.city}' '${cfg.country}' '${toString cfg.method}' '%h/.cache/prayer-times.json'";
          };
        };
      }
      # Merge with prayer services
      // mapAttrs'
        (prayer: delay:
          nameValuePair "prayer-${prayer}" {
            Unit = {
              Description = "${prayer} prayer reminder";
            };
            Service = {
              Type = "oneshot";
              ExecStart = "${pkgs.mpv}/bin/mpv --no-terminal --no-audio-display %h/athan.mp3";
            };
          }
        )
        prayers
      # Merge with hourly reminder if enabled
      // optionalAttrs cfg.enableHourlyReminders {
        hourly-reminder = {
          Unit = {
            Description = "Hourly reminder to stand up";
          };
          Service = {
            Type = "oneshot";
            ExecStart = "${pkgs.mpv}/bin/mpv --no-terminal --no-audio-display %h/stand.wav";
          };
        };
      };

    # Create all timers in ONE definition
    systemd.user.timers =
      # Fetch timer
      {
        fetch-prayer-times = {
          Unit = {
            Description = "Fetch prayer times daily";
          };
          Install = {
            WantedBy = [ "timers.target" ];
          };
          Timer = {
            OnBootSec = "1min";
            OnUnitActiveSec = "24h";
            Unit = "fetch-prayer-times.service";
          };
        };
      }
      # Merge with prayer timers
      // mapAttrs'
        (prayer: delay:
          nameValuePair "prayer-${prayer}" {
            Unit = {
              Description = "${prayer} prayer reminder timer";
            };
            Install = {
              WantedBy = [ "timers.target" ];
            };
            # Simple timer that runs every 24 hours
            Timer = {
              OnBootSec = "2min";
              OnUnitActiveSec = "24h";
              Unit = "prayer-${prayer}.service";
            };
          }
        )
        prayers
      # Merge with hourly reminder if enabled
      // optionalAttrs cfg.enableHourlyReminders {
        hourly-reminder = {
          Unit = {
            Description = "Hourly reminder to stand up";
          };
          Install = {
            WantedBy = [ "timers.target" ];
          };
          Timer = {
            OnBootSec = "5min";
            OnUnitActiveSec = "1h";
            Unit = "hourly-reminder.service";
          };
        };
      };
  };
}
