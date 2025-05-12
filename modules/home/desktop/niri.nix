# Niri home configuration
{ config, pkgs, lib, ... }:

{
  # Niri configuration
  programs.niri = {
    settings = {
      # Set environment variables
      environment = {
        "NIXOS_OZONE_WL" = "1";
        "MOZ_ENABLE_WAYLAND" = "1";
        "XDG_CURRENT_DESKTOP" = "niri";
        "DISPLAY" = ":0";
      };

      # Input device configuration
      input = {
        keyboard = {
          xkb = { };
        };

        touchpad = {
          enable = true;
          tap = true;
          natural-scroll = true;
        };

        mouse = {
          enable = true;
        };
      };

      # Output configuration
      outputs = {
        "DP-2" = {
          mode = {
            width = 2560;
            height = 1440;
            refresh = 165.056;
          };
          position = {
            x = 0;
            y = 0;
          };
          scale = 1.0;
        };
        "eDP-1" = {
          mode = {
            width = 2560;
            height = 1600;
            refresh = 165.0;
          };
          # position = {
          #   x = 0;
          #   y = 0;
          # };
          enable = false;
        };
      };

      # Layout settings
      layout = {
        focus-ring = {
          enable = false;
          width = 2;
          active = { color = "#74c7ec"; };
          inactive = { color = "#585b70"; };
        };

        border = {
          enable = true;
          width = 2;
          active = {
            gradient = {
              from = "#f38ba8";
              to = "#f9e2af";
              angle = 45;
              relative-to = "workspace-view";
            };
          };
          inactive = {
            gradient = {
              from = "#585b70";
              to = "#7f849c";
              angle = 45;
              relative-to = "workspace-view";
            };
          };
        };

        gaps = 4;

        preset-column-widths = [
          { proportion = 0.33333; } # 1/3
          { proportion = 0.5; } # 1/2
          { proportion = 0.66667; } # 2/3
        ];

        default-column-width = { proportion = 0.33333; };
      };

      # Prefer server-side decorations
      prefer-no-csd = true;

      # Spawn at startup
      spawn-at-startup = [
        { command = [ "swww-daemon" ]; }
        { command = [ "sh" "-c" "sleep 1 && swww img /home/mohakim/Downloads/star.png" ]; }
        # { command = [ "xwayland-satellite" ]; }
        { command = [ "wl-gammarelay-rs" "run" ]; }
      ];

      # Window rules
      window-rules = [
        # Apply rounded corners to ALL applications
        {
          matches = [{ }];
          geometry-corner-radius = {
            top-left = 6.0;
            top-right = 6.0;
            bottom-left = 6.0;
            bottom-right = 6.0;
          };
          clip-to-geometry = true;
        }

        # Librewolf transparency
        {
          matches = [
            { app-id = "librewolf"; }
          ];
          opacity = 0.90;
          draw-border-with-background = false;
        }

        # Obsidian transparency
        {
          matches = [
            { app-id = "obsidian"; }
          ];
          opacity = 0.90;
          draw-border-with-background = false;
        }
      ];

      # Key bindings
      binds = {
        "Mod+Shift+Slash".action.show-hotkey-overlay = { };

        "Ctrl+Tab".action.spawn = "alacritty";
        "Mod+F".action.spawn = "librewolf";
        "Mod+Space".action.spawn = "fuzzel";
        # "Super+Alt+L" = {
        #   action.spawn = "swaylock";
        #   allow-when-locked = true;
        # };

        "XF86AudioRaiseVolume" = {
          action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+" ];
          allow-when-locked = true;
        };
        "XF86AudioLowerVolume" = {
          action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-" ];
          allow-when-locked = true;
        };
        "XF86AudioMute" = {
          action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];
          allow-when-locked = true;
        };
        "XF86AudioMicMute" = {
          action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ];
          allow-when-locked = true;
        };

        "Ctrl+Escape".action.close-window = { };

        "Ctrl+K".action.focus-window-down = { };
        "Ctrl+I".action.focus-window-up = { };
        "Ctrl+J".action.focus-column-left = { };
        # "Mod+Down".action.focus-window-down = { };
        # "Mod+Up".action.focus-window-up = { };
        "Ctrl+L".action.focus-column-right = { };

        "Mod+J".action.move-column-left = { };
        "Mod+K".action.move-window-down = { };
        "Mod+I".action.move-window-up = { };
        "Mod+L".action.move-column-right = { };
        # "Mod+Ctrl+Left".action.move-column-left = { };
        # "Mod+Ctrl+Down".action.move-window-down = { };
        # "Mod+Ctrl+Up".action.move-window-up = { };
        # "Mod+Ctrl+Right".action.move-column-right = { };

        "Mod+Home".action.focus-column-first = { };
        "Mod+End".action.focus-column-last = { };
        "Mod+Ctrl+Home".action.move-column-to-first = { };
        "Mod+Ctrl+End".action.move-column-to-last = { };

        # "Mod+Shift+M".action.focus-monitor-left = { };
        # "Mod+Shift+N".action.focus-monitor-down = { };
        # "Mod+Shift+E".action.focus-monitor-up = { };
        # "Mod+Shift+I".action.focus-monitor-right = { };
        # "Mod+Shift+Left".action.focus-monitor-left = { };
        # "Mod+Shift+Down".action.focus-monitor-down = { };
        # "Mod+Shift+Up".action.focus-monitor-up = { };
        # "Mod+Shift+Right".action.focus-monitor-right = { };

        # "Mod+Shift+Ctrl+M".action.move-column-to-monitor-left = { };
        # "Mod+Shift+Ctrl+N".action.move-column-to-monitor-down = { };
        # "Mod+Shift+Ctrl+E".action.move-column-to-monitor-up = { };
        # "Mod+Shift+Ctrl+I".action.move-column-to-monitor-right = { };
        # "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = { };
        # "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = { };
        # "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = { };
        # "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = { };

        # "Mod+Shift+Alt+M".action.move-workspace-to-monitor-left = { };
        # "Mod+Shift+Alt+N".action.move-workspace-to-monitor-down = { };
        # "Mod+Shift+Alt+E".action.move-workspace-to-monitor-up = { };
        # "Mod+Shift+Alt+I".action.move-workspace-to-monitor-right = { };
        # "Mod+Shift+Alt+Left".action.move-workspace-to-monitor-left = { };
        # "Mod+Shift+Alt+Down".action.move-workspace-to-monitor-down = { };
        # "Mod+Shift+Alt+Up".action.move-workspace-to-monitor-up = { };
        # "Mod+Shift+Alt+Right".action.move-workspace-to-monitor-right = { };

        "Ctrl+O".action.focus-workspace-down = { };
        "Ctrl+U".action.focus-workspace-up = { };
        # "Mod+Page_Down".action.focus-workspace-down = { };
        # "Mod+Page_Up".action.focus-workspace-up = { };
        "Mod+Ctrl+L".action.move-column-to-workspace-down = { };
        "Mod+Ctrl+U".action.move-column-to-workspace-up = { };
        "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = { };
        "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = { };

        # "Mod+WheelScrollDown" = {
        #   action.focus-workspace-down = { };
        #   cooldown-ms = 150;
        # };
        # "Mod+WheelScrollUp" = {
        #   action.focus-workspace-up = { };
        #   cooldown-ms = 150;
        # };
        "Mod+WheelScrollDown" = {
          action.move-column-to-workspace-down = { };
          cooldown-ms = 150;
        };
        "Mod+WheelScrollUp" = {
          action.move-column-to-workspace-up = { };
          cooldown-ms = 150;
        };

        # "Mod+WheelScrollRight".action.focus-column-right = { };
        # "Mod+WheelScrollLeft".action.focus-column-left = { };
        # "Mod+Ctrl+WheelScrollRight".action.move-column-right = { };
        # "Mod+Ctrl+WheelScrollLeft".action.move-column-left = { };

        # "Mod+Shift+WheelScrollDown".action.focus-column-right = { };
        # "Mod+Shift+WheelScrollUp".action.focus-column-left = { };
        # "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = { };
        # "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = { };

        "Ctrl+Shift+WheelScrollUp" = {
          action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02+" ];
          cooldown-ms = 100;
        };
        "Ctrl+Shift+WheelScrollDown" = {
          action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02-" ];
          cooldown-ms = 100;
        };

        # "Mod+Shift+L".action.move-workspace-down = { };
        # "Mod+Shift+U".action.move-workspace-up = { };
        # "Mod+Shift+Page_Down".action.move-workspace-down = { };
        # "Mod+Shift+Page_Up".action.move-workspace-up = { };

        # "Mod+1".action.focus-workspace = 1;
        # "Mod+2".action.focus-workspace = 2;
        # "Mod+3".action.focus-workspace = 3;
        # "Mod+4".action.focus-workspace = 4;
        # "Mod+5".action.focus-workspace = 5;
        # "Mod+6".action.focus-workspace = 6;
        # "Mod+7".action.focus-workspace = 7;
        # "Mod+8".action.focus-workspace = 8;
        # "Mod+9".action.focus-workspace = 9;
        # "Mod+Ctrl+1".action.move-column-to-workspace = 1;
        # "Mod+Ctrl+2".action.move-column-to-workspace = 2;
        # "Mod+Ctrl+3".action.move-column-to-workspace = 3;
        # "Mod+Ctrl+4".action.move-column-to-workspace = 4;
        # "Mod+Ctrl+5".action.move-column-to-workspace = 5;
        # "Mod+Ctrl+6".action.move-column-to-workspace = 6;
        # "Mod+Ctrl+7".action.move-column-to-workspace = 7;
        # "Mod+Ctrl+8".action.move-column-to-workspace = 8;
        # "Mod+Ctrl+9".action.move-column-to-workspace = 9;

        "Mod+Comma".action.consume-window-into-column = { };
        "Mod+Period".action.expel-window-from-column = { };

        "Mod+BracketLeft".action.consume-or-expel-window-left = { };
        "Mod+BracketRight".action.consume-or-expel-window-right = { };

        "Mod+R".action.switch-preset-column-width = { };
        "Mod+M".action.maximize-column = { };
        "Mod+Shift+F".action.fullscreen-window = { };
        "Mod+C".action.center-column = { };
        "Mod+H".action.set-column-width = "50%";

        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Ctrl+Minus".action.set-column-width = "-1";
        "Mod+Ctrl+Equal".action.set-column-width = "+1";

        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";
        "Mod+Shift+Ctrl+Minus".action.set-window-height = "-1";
        "Mod+Shift+Ctrl+Equal".action.set-window-height = "+1";

        # "Mod+Space".action.switch-layout = "next";
        # "Mod+Shift+Space".action.switch-layout = "prev";
        "Mod+Shift+S".action.screenshot = { };

        # "Mod+Shift+Y".action.quit = { };
        "Mod+Shift+P".action.power-off-monitors = { };

        # "Mod+Shift+Ctrl+T".action.toggle-debug-tint = { };
        # "Mod+Shift+Ctrl+O".action.debug-toggle-opaque-regions = { };
        # "Mod+Shift+Ctrl+D".action.debug-toggle-damage = { };

        # Mouse wheel bindings for brightness
        "Ctrl+Alt+WheelScrollUp" = {
          action.spawn = [ "busctl" "--user" "call" "rs.wl-gammarelay" "/" "rs.wl.gammarelay" "UpdateBrightness" "d" "0.05" ];
          cooldown-ms = 100;
        };
        "Ctrl+Alt+WheelScrollDown" = {
          action.spawn = [ "busctl" "--user" "--" "call" "rs.wl-gammarelay" "/" "rs.wl.gammarelay" "UpdateBrightness" "d" "-0.05" ];
          cooldown-ms = 100;
        };

        # Mouse wheel bindings for warmth/temperature
        "Ctrl+Mod+WheelScrollUp" = {
          action.spawn = [ "busctl" "--user" "call" "rs.wl-gammarelay" "/" "rs.wl.gammarelay" "UpdateTemperature" "n" "100" ];
          cooldown-ms = 100;
        };
        "Ctrl+Mod+WheelScrollDown" = {
          action.spawn = [ "busctl" "--user" "--" "call" "rs.wl-gammarelay" "/" "rs.wl.gammarelay" "UpdateTemperature" "n" "-100" ];
          cooldown-ms = 100;
        };
      };
    };
  };
}
