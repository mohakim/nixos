{ config, pkgs, lib, ... }:

let
  # Configuration
  cfg = {
    city = "Kuala Lumpur";
    country = "Malaysia";
    method = 3;
    fajrDelay = 15;
    dhuhrDelay = 15;
    asrDelay = 15;
    maghribDelay = 5;
    ishaDelay = 15;
  };

  # Get current date for API call
  date = builtins.substring 0 10 (builtins.readFile
    (pkgs.runCommand "today" { } ''date +"%d-%m-%Y" > $out''));

  # Fetch prayer times at build time
  prayerTimesJson = builtins.fromJSON (builtins.readFile
    (pkgs.fetchurl {
      url = "https://api.aladhan.com/v1/timingsByCity/${date}?city=${lib.strings.urlEncode cfg.city}&country=${lib.strings.urlEncode cfg.country}&method=${toString cfg.method}";
      sha256 = pkgs.runCommand "prayer-times-sha" { } ''
        ${pkgs.curl}/bin/curl -s "https://api.aladhan.com/v1/timingsByCity/${date}?city=${lib.strings.urlEncode cfg.city}&country=${lib.strings.urlEncode cfg.country}&method=${toString cfg.method}" | ${pkgs.nix}/bin/nix-hash --type sha256 --base32 --flat - > $out
      '';
    }));

  # Extract prayer times
  prayerTimes = prayerTimesJson.data.timings;

  # Function to add delay to prayer time
  addDelay = time: delay:
    let
      hour = lib.strings.toInt (builtins.substring 0 2 time);
      minute = lib.strings.toInt (builtins.substring 3 5 time);
      totalMinutes = hour * 60 + minute + delay;
      newHour = totalMinutes / 60;
      newMinute = totalMinutes - (newHour * 60);
      formatNum = num: if num < 10 then "0${toString num}" else toString num;
    in
    "${formatNum newHour}:${formatNum newMinute}:00";

  # List of prayers with their delays
  prayers = {
    Fajr = cfg.fajrDelay;
    Dhuhr = cfg.dhuhrDelay;
    Asr = cfg.asrDelay;
    Maghrib = cfg.maghribDelay;
    Isha = cfg.ishaDelay;
  };

  # Calculate notification times
  notificationTimes = lib.mapAttrs
    (prayer: delay:
      addDelay (builtins.getAttr prayer prayerTimes) delay
    )
    prayers;

  # Function to create a prayer service (just plays sound)
  mkPrayerService = prayer: _: {
    description = "${prayer} prayer reminder";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.mpv}/bin/mpv --no-terminal %h/takbiir.mp3";
    };
  };

  # Function to create a prayer timer with fixed calendar time
  mkPrayerTimer = prayer: time: {
    description = "${prayer} prayer reminder";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* ${time}"; # Fixed time based on build-time calculation
      Persistent = true; # Run immediately if system was off at scheduled time
      Unit = "prayer-${prayer}.service";
    };
  };

  # Generate prayer services and timers
  prayerServices = lib.mapAttrs mkPrayerService prayers;
  prayerTimers = lib.mapAttrs mkPrayerTimer notificationTimes;

in
{
  # Install required packages
  environment.systemPackages = with pkgs; [
    mpv
  ];

  # Create the prayer reminder services
  systemd.user.services = lib.recursiveUpdate prayerServices {
    hourly-reminder = {
      description = "Hourly reminder to stand up";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.mpv}/bin/mpv --no-terminal %h/hourly-reminder.mp3";
      };
    };
  };

  # Create the timers
  systemd.user.timers = lib.recursiveUpdate prayerTimers {
    hourly-reminder = {
      description = "Hourly reminder to stand up";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "5min";
        OnUnitActiveSec = "1h";
        Unit = "hourly-reminder.service";
      };
    };
  };
}
