# System-wide Niri configuration
{ config, pkgs, lib, niri, username, ... }:

with lib;
let
  cfg = config.modules.desktop.niri;
in
{
  options.modules.desktop.niri = {
    enable = mkEnableOption "Enable Niri window manager";

    package = mkOption {
      type = types.package;
      default = pkgs.niri-stable;
      description = "The Niri package to use (stable or unstable)";
    };

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable Niri auto-start in the display manager";
    };

    # User configuration options
    wallpaper = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Path to wallpaper image";
    };

    cornerRadius = mkOption {
      type = types.float;
      default = 6.0;
      description = "Window corner radius";
    };

    transparentApps = mkOption {
      type = types.listOf types.attrs;
      default = [
        { app-id = "librewolf"; opacity = 0.90; }
        { app-id = "obsidian"; opacity = 0.90; }
      ];
      description = "Applications to make transparent";
    };

    keyBindings = mkOption {
      type = types.attrs;
      default = { };
      description = "Additional key bindings";
    };

    outputs = mkOption {
      type = types.attrs;
      default = { };
      description = "Output configuration";
    };

    startupPrograms = mkOption {
      type = types.listOf types.attrs;
      default = [
        { command = [ "swww-daemon" ]; }
        { command = [ "xwayland-satellite" ]; }
        { command = [ "wl-gammarelay-rs" "run" ]; }
      ];
      description = "Programs to start at Niri startup";
    };
  };

  config = mkIf cfg.enable
    {
      # Add the niri overlay to make niri packages available
      nixpkgs.overlays = [ niri.overlays.niri ];

      # Configure the display manager to use Niri
      services.greetd = mkIf cfg.autoStart {
        enable = true;
        settings = {
          default_session = {
            command = "niri --session";
            user = username;
          };
        };
      };

      # Add environment variables for Wayland
      environment.sessionVariables = {
        "NIXOS_OZONE_WL" = "1";
        "MOZ_ENABLE_WAYLAND" = "1";
        "XDG_CURRENT_DESKTOP" = "niri";
      };

      # Install necessary packages
      environment.systemPackages = with pkgs; [
        wl-gammarelay-rs
        xwayland-satellite
        swww
      ];

      # Enable Niri window manager
      programs.niri = {
        enable = true;
        package = cfg.package;
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
          outputs = if cfg.outputs != { } then cfg.outputs else {
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
          spawn-at-startup = cfg.startupPrograms ++ (optional (cfg.wallpaper != null) {
            command = [ "sh" "-c" "sleep 1 && swww img ${cfg.wallpaper}" ];
          });

          # Window rules
          window-rules = [
            # Apply rounded corners to ALL applications
            {
              matches = [{ }];
              geometry-corner-radius = {
                top-left = cfg.cornerRadius;
                top-right = cfg.cornerRadius;
                bottom-left = cfg.cornerRadius;
                bottom-right = cfg.cornerRadius;
              };
              clip-to-geometry = true;
            }
          ] ++ (map
            (app: {
              matches = [{ app-id = app.app-id; }];
              opacity = app.opacity;
              draw-border-with-background = false;
            })
            cfg.transparentApps);

          # Key bindings - default set
          binds = {
            "Mod+Shift+Slash".action.show-hotkey-overlay = { };

            "Ctrl+Tab".action.spawn = "alacritty";
            "Mod+F".action.spawn = "librewolf";
            "Mod+Space".action.spawn = "fuzzel";

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
            "Ctrl+L".action.focus-column-right = { };

            "Mod+J".action.move-column-left = { };
            "Mod+K".action.move-window-down = { };
            "Mod+I".action.move-window-up = { };
            "Mod+L".action.move-column-right = { };
          } // cfg.keyBindings;
        };
      };
    };

}
