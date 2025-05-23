{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.custom.cli.reminders;

  # Use proper XDG directories (addressing point 7)
  cacheDir = "${config.xdg.cacheHome}/prayer-times";

  # Helper function to create prayer services with proper structure
  createPrayerService = prayer: {
    name = "prayer-reminder-${toLower prayer}";
    value = {
      Unit = {
        Description = "${prayer} prayer reminder";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.mpv}/bin/mpv --no-terminal --no-audio-display $HOME/athan.mp3";
        Environment = [ "PRAYER_NAME=${prayer}" ];
      };
    };
  };

  # Prayer time fetcher and transient timer creator (addressing points 13, 21, 22)
  # This script will create transient timers directly in memory without files
  setupScript = pkgs.writeShellScript "setup-prayer-times" ''
    #!/usr/bin/env bash
    set -euo pipefail
    
    # Use proper XDG directories
    XDG_CACHE_HOME=''${XDG_CACHE_HOME:-$HOME/.cache}
    CACHE_DIR="${cacheDir}"
    mkdir -p "$CACHE_DIR"
    
    # Get current date and time for comparison
    CURRENT_DATE=$(date +"%d-%m-%Y")
    CURRENT_HOUR=$(date +"%H")
    CURRENT_MINUTE=$(date +"%M")
    CURRENT_TOTAL_MINUTES=$((CURRENT_HOUR * 60 + CURRENT_MINUTE))
    
    # Properly encode URL parameters to prevent injection
    CITY_ENCODED=$(${pkgs.curl}/bin/curl -Gso /dev/null -w %{url_effective} --data-urlencode "city=${cfg.city}" "" | cut -c 3-)
    COUNTRY_ENCODED=$(${pkgs.curl}/bin/curl -Gso /dev/null -w %{url_effective} --data-urlencode "country=${cfg.country}" "" | cut -c 3-)
    
    # Fetch prayer times
    PRAYER_DATA=$(${pkgs.curl}/bin/curl -s "https://api.aladhan.com/v1/timingsByCity/$CURRENT_DATE?city=$CITY_ENCODED&country=$COUNTRY_ENCODED&method=${toString cfg.method}")
    
    # Stop all existing timers with pattern match (clean slate)
    systemctl --user stop prayer-reminder-{fajr,dhuhr,asr,maghrib,isha}.timer 2>/dev/null || true
    
    # Process prayer times - directly find and schedule only the next prayers (addressing point 11)
    ${pkgs.jq}/bin/jq -r '.data.timings | to_entries[] | select(["Fajr","Dhuhr","Asr","Maghrib","Isha"] | index(.key)) | .key + " " + .value' <<< "$PRAYER_DATA" | while read PRAYER TIME; do
      # Get delay from parameters
      case "$PRAYER" in
        Fajr) DELAY=${toString cfg.fajrDelay} ;;
        Dhuhr) DELAY=${toString cfg.dhuhrDelay} ;;
        Asr) DELAY=${toString cfg.asrDelay} ;;
        Maghrib) DELAY=${toString cfg.maghribDelay} ;;
        Isha) DELAY=${toString cfg.ishaDelay} ;;
      esac
      
      # Parse time and add delay
      HOUR=$(echo $TIME | cut -d ':' -f 1)
      MINUTE=$(echo $TIME | cut -d ':' -f 2)
      
      # Add delay
      TOTAL_MINUTES=$((HOUR * 60 + MINUTE + DELAY))
      NEW_HOUR=$((TOTAL_MINUTES / 60))
      NEW_MINUTE=$((TOTAL_MINUTES % 60))
      
      # Format time for systemd timer - correct format without seconds
      TIMER_TIME=$(printf "*-*-* %02d:%02d" $NEW_HOUR $NEW_MINUTE)
      
      # Calculate total minutes for comparison
      PRAYER_TOTAL_MINUTES=$((NEW_HOUR * 60 + NEW_MINUTE))
      
      # Only schedule prayers that haven't occurred yet today (addressing point 11)
      if [ $PRAYER_TOTAL_MINUTES -gt $CURRENT_TOTAL_MINUTES ]; then
        echo "Scheduling $PRAYER for today at $TIMER_TIME"
        
        # Use systemd-run to create a transient timer directly (addressing points 13 and 22)
        # This avoids files completely by creating the timer in memory
        ${pkgs.systemd}/bin/systemd-run --user \
          --unit="prayer-reminder-''${PRAYER,,}" \
          --description="$PRAYER prayer reminder" \
          --on-calendar="$TIMER_TIME" \
          --service-type=oneshot \
          ${pkgs.mpv}/bin/mpv --no-terminal --no-audio-display "$HOME/athan.mp3"
        
        echo "Created transient timer for $PRAYER at $TIMER_TIME"
      fi
    done
  '';
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
    home.packages = with pkgs; [ mpv jq ];

    # Create directory structure declaratively (addressing point 7)
    xdg.cacheHome = mkDefault "${config.home.homeDirectory}/.cache";

    # Ensure cache directory exists
    systemd.user.tmpfiles.rules = [
      "d ${cacheDir} 0755 ${config.home.username} users -"
    ];

    # Only define the setup service - all prayer timers are created dynamically
    systemd.user.services = {
      # Setup service that runs on boot
      setup-prayer-times = {
        Unit = {
          Description = "Fetch and setup prayer times for today";
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${setupScript}";
        };
      };
    } // optionalAttrs cfg.enableHourlyReminders {
      hourly-reminder = {
        Unit = {
          Description = "Hourly reminder to stand up";
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.mpv}/bin/mpv --no-terminal --no-audio-display $HOME/stand.wav";
        };
      };
    };

    # Only define the setup timer and hourly reminder - prayer timers are handled dynamically
    systemd.user.timers = {
      # Setup timer runs at boot and daily (addressing point 22)
      setup-prayer-times = {
        Unit = {
          Description = "Fetch and setup prayer times daily";
        };
        Install = {
          WantedBy = [ "timers.target" ];
        };
        Timer = {
          OnBootSec = "1min"; # Run 1 minute after boot
          OnCalendar = "*-*-* 00:01"; # Run daily at 00:01 (no seconds)
          Persistent = true;
        };
      };
    } // optionalAttrs cfg.enableHourlyReminders {
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
          Persistent = true;
        };
      };
    };
  };
}
