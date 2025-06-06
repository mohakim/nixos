# WasIstLos (WhatsApp client) configuration
{ pkgs, ... }:

{
  home.packages = [ pkgs.wasistlos ];

  # Override the desktop entry to show as "WhatsApp"
  xdg.desktopEntries = {
    whatsapp = {
      name = "WhatsApp";
      comment = "WhatsApp Desktop Client";
      exec = "wasistlos %U";
      icon = "whatsapp";
      categories = [ "Network" "InstantMessaging" "Chat" ];
      type = "Application";
      terminal = false;
      startupNotify = true;
      mimeType = [ "x-scheme-handler/whatsapp" ];
    };

    wasistlos = {
      name = "WasIstLos";
      noDisplay = true;
    };

    "com.github.xeco23.WasIstLos" = {
      name = "WasIstLos";
      noDisplay = true;
    };
  };

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
