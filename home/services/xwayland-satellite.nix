{ pkgs, ... }:

{
  systemd.user.services.xwayland-satellite = {
    Unit = {
      Description = "Xwayland outside your Wayland";
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
      Restart = "on-failure";
      RestartSec = "1";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
