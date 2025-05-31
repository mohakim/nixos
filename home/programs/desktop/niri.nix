{ ... }:

{
  programs.niri = {
    settings = {
      # Input device configuration
      input = {
        keyboard.xkb = { };
        touchpad = {
          enable = true;
          tap = true;
          natural-scroll = true;
        };
        mouse.enable = true;
      };

      # Output configuration
      outputs = {
        "DP-2" = {
          mode = {
            width = 2560;
            height = 1440;
            refresh = 165.056;
          };
          position = { x = 0; y = 0; };
          scale = 1.0;
        };
        "eDP-1" = {
          mode = {
            width = 2560;
            height = 1600;
            refresh = 165.0;
          };
          position = { x = 0; y = 0; };
          enable = false;
        };
      };

      # Layout settings
      layout = {
        focus-ring = {
          enable = false;
          width = 2;
          active.color = "#74c7ec";
          inactive.color = "#585b70";
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
          { proportion = 0.33333; }
          { proportion = 0.5; }
          { proportion = 0.66667; }
        ];
        default-column-width = { proportion = 0.33333; };
      };

      prefer-no-csd = true;

      # Startup applications
      spawn-at-startup = [
        { command = [ "swww-daemon" ]; }
        { command = [ "sh" "-c" "sleep 1 && swww img /home/mohakim/Downloads/blackhole.png" ]; }
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

        # Application-specific transparency
        {
          matches = [{ app-id = "librewolf"; }];
          opacity = 0.90;
          draw-border-with-background = false;
        }
        {
          matches = [{ app-id = "Alacritty"; }];
          opacity = 0.90;
          draw-border-with-background = false;
        }
        {
          matches = [{ app-id = "obsidian"; }];
          opacity = 0.90;
          draw-border-with-background = false;
        }
      ];

      # Key bindings
      binds = {
        "Mod+Shift+Slash".action.show-hotkey-overlay = { };

        # Application launchers
        "Ctrl+Tab".action.spawn = "alacritty";
        "Mod+F".action.spawn = "librewolf";
        "Mod+Space".action.spawn = "fuzzel";

        # Audio controls
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

        # Audio device switching
        "Mod+1".action.spawn = [ "fish" "-c" "source ~/.config/fish/config.fish; toggle-audio family" ];
        "Mod+2".action.spawn = [ "fish" "-c" "source ~/.config/fish/config.fish; toggle-audio headset" ];
        "Mod+3".action.spawn = [ "fish" "-c" "source ~/.config/fish/config.fish; toggle-audio earbuds" ];

        # Window management
        "Ctrl+Escape".action.close-window = { };

        # Focus management
        "Ctrl+K".action.focus-window-down = { };
        "Ctrl+I".action.focus-window-up = { };
        "Ctrl+J".action.focus-column-left = { };
        "Ctrl+L".action.focus-column-right = { };

        # Column movement
        "Ctrl+Mod+J".action.move-column-left = { };
        "Ctrl+Mod+L".action.move-column-right = { };
        "Mod+Home".action.focus-column-first = { };
        "Mod+End".action.focus-column-last = { };
        "Mod+Ctrl+Home".action.move-column-to-first = { };
        "Mod+Ctrl+End".action.move-column-to-last = { };

        # Workspace navigation
        "Ctrl+O".action.focus-workspace-down = { };
        "Ctrl+U".action.focus-workspace-up = { };

        # Workspace movement with mouse wheel
        "Mod+WheelScrollDown" = {
          action.move-column-to-workspace-down = { };
          cooldown-ms = 150;
        };
        "Mod+WheelScrollUp" = {
          action.move-column-to-workspace-up = { };
          cooldown-ms = 150;
        };

        # Volume control with wheel
        "Ctrl+Shift+WheelScrollUp" = {
          action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+" ];
          cooldown-ms = 200;
        };
        "Ctrl+Shift+WheelScrollDown" = {
          action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-" ];
          cooldown-ms = 200;
        };

        # Window arrangement
        "Mod+Comma".action.consume-window-into-column = { };
        "Mod+Period".action.expel-window-from-column = { };
        "Mod+BracketLeft".action.consume-or-expel-window-left = { };
        "Mod+BracketRight".action.consume-or-expel-window-right = { };

        # Layout controls
        "Mod+R".action.switch-preset-column-width = { };
        "Mod+M".action.maximize-column = { };
        "Mod+Shift+F".action.fullscreen-window = { };
        "Mod+C".action.center-column = { };
        "Mod+H".action.set-column-width = "50%";

        # Resize controls
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Ctrl+Minus".action.set-column-width = "-1";
        "Mod+Ctrl+Equal".action.set-column-width = "+1";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";
        "Mod+Shift+Ctrl+Minus".action.set-window-height = "-1";
        "Mod+Shift+Ctrl+Equal".action.set-window-height = "+1";

        # Screenshot and power
        "Mod+Shift+S".action.screenshot = { };
        "Mod+Shift+P".action.power-off-monitors = { };

        # Brightness control with mouse wheel
        "Ctrl+Alt+WheelScrollUp" = {
          action.spawn = [ "busctl" "--user" "call" "rs.wl-gammarelay" "/" "rs.wl.gammarelay" "UpdateBrightness" "d" "0.05" ];
          cooldown-ms = 100;
        };
        "Ctrl+Alt+WheelScrollDown" = {
          action.spawn = [ "busctl" "--user" "--" "call" "rs.wl-gammarelay" "/" "rs.wl.gammarelay" "UpdateBrightness" "d" "-0.05" ];
          cooldown-ms = 100;
        };

        # Temperature control with mouse wheel
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
