{ config, pkgs, ... }:

let
  cacheDir = "${config.xdg.cacheHome}/prayer-times";

  # Prayer time setup script
  setupScript = pkgs.writeShellScript "setup-prayer-times" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail
    
    XDG_CACHE_HOME=''${XDG_CACHE_HOME:-$HOME/.cache}
    CACHE_DIR="${cacheDir}"
    ${pkgs.coreutils}/bin/mkdir -p "$CACHE_DIR"
    
    CURRENT_DATE=$(${pkgs.coreutils}/bin/date +"%d-%m-%Y")
    CURRENT_HOUR=$(${pkgs.coreutils}/bin/date +"%H")
    CURRENT_MINUTE=$(${pkgs.coreutils}/bin/date +"%M")
    CURRENT_TOTAL_MINUTES=$((CURRENT_HOUR * 60 + CURRENT_MINUTE))
 
    PRAYER_DATA=$(${pkgs.curl}/bin/curl -s "https://api.aladhan.com/v1/timingsByCity/$CURRENT_DATE?city=Kuala%20Lumpur&country=Malaysia&method=3")
    
    ${pkgs.systemd}/bin/systemctl --user stop prayer-reminder-{fajr,dhuhr,asr,maghrib,isha}.timer 2>/dev/null || true
    
    ${pkgs.jq}/bin/jq -r '.data.timings | {Fajr, Dhuhr, Asr, Maghrib, Isha} | to_entries[] | .key + " " + .value' <<< "$PRAYER_DATA" | while read PRAYER TIME; do
      case "$PRAYER" in
        Fajr) DELAY=15 ;;
        Dhuhr) DELAY=15 ;;
        Asr) DELAY=15 ;;
        Maghrib) DELAY=5 ;;
        Isha) DELAY=15 ;;
      esac
      
      HOUR=$(${pkgs.coreutils}/bin/echo $TIME | ${pkgs.coreutils}/bin/cut -d ':' -f 1)
      MINUTE=$(${pkgs.coreutils}/bin/echo $TIME | ${pkgs.coreutils}/bin/cut -d ':' -f 2)
      
      TOTAL_MINUTES=$((HOUR * 60 + MINUTE + DELAY))
      NEW_HOUR=$((TOTAL_MINUTES / 60))
      NEW_MINUTE=$((TOTAL_MINUTES % 60))
      
      TIMER_TIME=$(${pkgs.coreutils}/bin/printf "*-*-* %02d:%02d" $NEW_HOUR $NEW_MINUTE)
      PRAYER_TOTAL_MINUTES=$((NEW_HOUR * 60 + NEW_MINUTE))
      
      if [ $PRAYER_TOTAL_MINUTES -gt $CURRENT_TOTAL_MINUTES ]; then
        ${pkgs.coreutils}/bin/echo "Scheduling $PRAYER for today at $TIMER_TIME"
        
        ${pkgs.systemd}/bin/systemd-run --user \
          --unit="prayer-reminder-''${PRAYER,,}" \
          --description="$PRAYER prayer reminder" \
          --on-calendar="$TIMER_TIME" \
          --service-type=oneshot \
          ${pkgs.mpv}/bin/mpv --no-terminal --no-audio-display "$HOME/athan.mp3"
        
        ${pkgs.coreutils}/bin/echo "Created transient timer for $PRAYER at $TIMER_TIME"
      fi
    done
  '';
in
{
  home.packages = [ pkgs.jq ];

  xdg.cacheHome = config.home.homeDirectory + "/.cache";

  systemd.user = {
    tmpfiles.rules = [
      "d ${cacheDir} 0755 ${config.home.username} users -"
    ];

    services = {
      setup-prayer-times = {
        Unit.Description = "Fetch and setup prayer times for today";
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.bash}/bin/bash ${setupScript}";
        };
      };

      hourly-reminder = {
        Unit.Description = "Hourly reminder to stand up";
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.mpv}/bin/mpv --no-terminal --no-audio-display $HOME/stand.wav";
        };
      };
    };

    timers = {
      setup-prayer-times = {
        Unit.Description = "Fetch and setup prayer times daily";
        Install.WantedBy = [ "timers.target" ];
        Timer = {
          OnBootSec = "1min";
          OnCalendar = "*-*-* 00:01";
          Persistent = true;
        };
      };

      hourly-reminder = {
        Unit.Description = "Hourly reminder to stand up";
        Install.WantedBy = [ "timers.target" ];
        Timer = {
          OnBootSec = "5min";
          OnUnitActiveSec = "1h";
          Persistent = true;
        };
      };
    };
  };
}
