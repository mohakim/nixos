{ pkgs, ... }:

{
  systemd.user.services.wl-gammarelay = {
    Unit = {
      Description = "DBus interface to control display temperature and brightness under wayland";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "dbus";
      BusName = "rs.wl-gammarelay";
      ExecStart = "${pkgs.wl-gammarelay-rs}/bin/wl-gammarelay-rs run";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
