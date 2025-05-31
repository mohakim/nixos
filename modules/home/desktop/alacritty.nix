# Alacritty terminal configuration module
{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.custom.desktop.alacritty;
in
{
  options.custom.desktop.alacritty = {
    enable = mkEnableOption "Enable Alacritty terminal configuration";

    fontSize = mkOption {
      type = types.float;
      default = 14.0;
      description = "Font size";
    };

    fontFamily = mkOption {
      type = types.str;
      default = "JetBrainsMonoNL Nerd Font";
      description = "Font family";
    };

    shell = mkOption {
      type = types.str;
      default = "fish";
      description = "Default shell";
    };

    theme = mkOption {
      type = types.enum [ "catppuccin-mocha" "catppuccin-macchiato" "catppuccin-frappe" "catppuccin-latte" ];
      default = "catppuccin-mocha";
      description = "Color theme";
    };
  };

  config = mkIf cfg.enable {
    # Enable Alacritty
    programs.alacritty = {
      enable = true;
      settings = {
        # Shell configuration
        terminal.shell = {
          program = "${pkgs.${cfg.shell}}/bin/${cfg.shell}";
        };

        # Font configuration
        font = {
          normal = {
            family = cfg.fontFamily;
            style = "Mono";
          };
          bold = {
            family = cfg.fontFamily;
            style = "Bold";
          };
          italic = {
            family = cfg.fontFamily;
            style = "Italic";
          };
          bold_italic = {
            family = cfg.fontFamily;
            style = "Bold Italic";
          };
          size = cfg.fontSize;
          builtin_box_drawing = true;

          offset = {
            x = 0;
            y = 0;
          };
          glyph_offset = {
            x = 0;
            y = 0;
          };
        };

        # Mouse settings
        mouse = {
          hide_when_typing = true;
        };

        # Window configuration
        window = {
          padding = {
            x = 8;
            y = 8;
          };
          decorations = "full";
          dynamic_title = true;
        };

        general.ipc_socket = true;

        # Selection settings
        selection = {
          save_to_clipboard = false;
        };

        # Catppuccin Mocha theme
        colors = {
          primary = {
            background = "#1e1e2e";
            foreground = "#cdd6f4";
            dim_foreground = "#7f849c";
            bright_foreground = "#cdd6f4";
          };

          cursor = {
            text = "#1e1e2e";
            cursor = "#f5e0dc";
          };

          vi_mode_cursor = {
            text = "#1e1e2e";
            cursor = "#b4befe";
          };

          search = {
            matches = {
              foreground = "#1e1e2e";
              background = "#a6adc8";
            };
            focused_match = {
              foreground = "#1e1e2e";
              background = "#a6e3a1";
            };
          };

          footer_bar = {
            foreground = "#1e1e2e";
            background = "#a6adc8";
          };

          hints = {
            start = {
              foreground = "#1e1e2e";
              background = "#f9e2af";
            };
            end = {
              foreground = "#1e1e2e";
              background = "#a6adc8";
            };
          };

          selection = {
            text = "#1e1e2e";
            background = "#f5e0dc";
          };

          normal = {
            black = "#45475a";
            red = "#f38ba8";
            green = "#a6e3a1";
            yellow = "#f9e2af";
            blue = "#89b4fa";
            magenta = "#f5c2e7";
            cyan = "#94e2d5";
            white = "#bac2de";
          };

          bright = {
            black = "#585b70";
            red = "#f38ba8";
            green = "#a6e3a1";
            yellow = "#f9e2af";
            blue = "#89b4fa";
            magenta = "#f5c2e7";
            cyan = "#94e2d5";
            white = "#a6adc8";
          };

          dim = {
            black = "#45475a";
            red = "#f38ba8";
            green = "#a6e3a1";
            yellow = "#f9e2af";
            blue = "#89b4fa";
            magenta = "#f5c2e7";
            cyan = "#94e2d5";
            white = "#bac2de";
          };

          indexed_colors = [
            { index = 16; color = "#fab387"; }
            { index = 17; color = "#f5e0dc"; }
          ];
        };
      };
    };
  };
}
