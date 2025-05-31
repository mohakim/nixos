# Mako notification daemon configuration module
{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.custom.desktop.mako;

  # Catppuccin Mocha color palette
  colors = {
    rosewater = "#f5e0dc";
    flamingo = "#f2cdcd";
    pink = "#f5c2e7";
    mauve = "#cba6f7";
    red = "#f38ba8";
    maroon = "#eba0ac";
    peach = "#fab387";
    yellow = "#f9e2af";
    green = "#a6e3a1";
    teal = "#94e2d5";
    sky = "#89dceb";
    sapphire = "#74c7ec";
    blue = "#89b4fa";
    lavender = "#b4befe";
    text = "#cdd6f4";
    subtext1 = "#bac2de";
    subtext0 = "#a6adc8";
    overlay2 = "#9399b2";
    overlay1 = "#7f849c";
    overlay0 = "#6c7086";
    surface2 = "#585b70";
    surface1 = "#45475a";
    surface0 = "#313244";
    base = "#1e1e2e";
    mantle = "#181825";
    crust = "#11111b";
  };
in
{
  options.custom.desktop.mako = {
    enable = mkEnableOption "Enable Mako notification daemon with Catppuccin Mocha theme";

    timeout = mkOption {
      type = types.int;
      default = 5000;
      description = "Default notification timeout in milliseconds";
    };

    maxVisible = mkOption {
      type = types.int;
      default = 5;
      description = "Maximum number of visible notifications";
    };

    position = mkOption {
      type = types.enum [ "top-left" "top-center" "top-right" "bottom-left" "bottom-center" "bottom-right" ];
      default = "top-right";
      description = "Position of notifications on screen";
    };

    width = mkOption {
      type = types.int;
      default = 400;
      description = "Notification width in pixels";
    };

    height = mkOption {
      type = types.int;
      default = 120;
      description = "Maximum notification height in pixels";
    };

    borderRadius = mkOption {
      type = types.int;
      default = 8;
      description = "Border radius for rounded corners";
    };

    font = mkOption {
      type = types.str;
      default = "JetBrainsMono Nerd Font 11";
      description = "Font for notifications";
    };
  };

  config = mkIf cfg.enable {
    # Configure mako using the correct services.mako.settings approach
    services.mako = {
      enable = true;

      # Use the structured settings approach
      settings = {
        # Global default settings
        font = cfg.font;
        width = cfg.width;
        height = cfg.height;
        margin = "20";
        padding = "15,20";
        border-size = 2;
        border-radius = cfg.borderRadius;
        background-color = colors.base;
        text-color = colors.text;
        border-color = colors.blue;
        progress-color = "over ${colors.surface0}";

        # Positioning and behavior
        anchor = cfg.position;
        max-visible = cfg.maxVisible;
        sort = "-time";
        layer = "overlay";
        default-timeout = cfg.timeout;
        ignore-timeout = false;

        # Features
        markup = true;
        actions = true;
        history = true;
        text-alignment = "left";
        max-icon-size = 48;

        # Group notifications by app-name
        group-by = "app-name";
      };
    };

    # Install mako and dependencies
    home.packages = with pkgs; [
      mako
      libnotify # for notify-send testing
    ];

    # Manual systemd user service (since home-manager doesn't provide one)
    systemd.user.services.mako = {
      Unit = {
        Description = "Mako notification daemon";
        Documentation = "man:mako(1)";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };
      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "${pkgs.mako}/bin/mako";
        ExecReload = "${pkgs.mako}/bin/makoctl reload";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
