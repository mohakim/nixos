# WasIstLos (WhatsApp client) configuration
{ pkgs, ... }:

{
  home.packages = [ pkgs.wasistlos ];

  home.file.".config/wasistlos/settings.conf".source =
    (pkgs.formats.ini { }).generate "wasistlos-settings" {
      web = {
        allow-permissions = true;
        hw-accel = 1;
        min-font-size = 0;
      };
      general = {
        close-to-tray = false;
        start-in-tray = false;
        start-minimized = false;
        header-bar = false;
        zoom-level = 1;
        notification-sounds = true;
      };
      appearance = {
        prefer-dark-theme = true;
      };
    };
}
