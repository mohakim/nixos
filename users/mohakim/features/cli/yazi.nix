# Yazi file manager configuration
{ config, pkgs, lib, ... }:

{
  # Enable Yazi file manager
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      # General settings
      manager = {
        show_hidden = true;
        sort_by = "natural";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;

        # Show symlink targets
        linemode = "size";
      };

      # Opening behavior
      opener = {
        edit = [
          { run = "hx \"$@\""; block = true; }
        ];

        text = [
          { run = "hx \"$@\""; block = true; }
        ];

        video = [
          { run = "mpv \"$@\""; block = false; }
        ];

        audio = [
          { run = "mpv \"$@\""; block = false; }
        ];

        pdf = [
          { run = "librewolf \"$@\""; block = false; }
        ];

        fallback = [
          { run = "xdg-open \"$@\""; block = false; }
        ];
      };

      # Theme using Catppuccin Mocha
      theme = {
        selection = "#585b70";
        selection-match = "#fab387";

        # File colors
        file = {
          name = { fg = "#cdd6f4"; };
          link = { fg = "#89b4fa"; };
          broken = { fg = "#f38ba8"; };
          dir = { fg = "#89b4fa"; bold = true; };
          exec = { fg = "#a6e3a1"; };
          hidden = { fg = "#6c7086"; };
          image = { fg = "#f9e2af"; };
          video = { fg = "#f5c2e7"; };
          music = { fg = "#89b4fa"; };
          lossless = { fg = "#89dceb"; };
          crypto = { fg = "#cba6f7"; };
          document = { fg = "#f9e2af"; };
          archive = { fg = "#f38ba8"; };
          temp = { fg = "#9399b2"; };
        };

        status = {
          separator_open = "";
          separator_close = "";
          mode = { fg = "#1e1e2e"; bg = "#89b4fa"; bold = true; };
          info = { fg = "#cdd6f4"; bold = true; };
          job = { fg = "#f9e2af"; bg = "#1e1e2e"; };
          count = { fg = "#1e1e2e"; bg = "#89b4fa"; };
          size = { fg = "#1e1e2e"; bg = "#f9e2af"; };
          permissions = { fg = "#1e1e2e"; bg = "#a6e3a1"; };
          mtime = { fg = "#1e1e2e"; bg = "#cba6f7"; };
          rule = { fg = "#6c7086"; };
        };

        border = {
          fg = "#cdd6f4";
          bg = "#1e1e2e";
          corner = "┌";
        };

        help = {
          on = { fg = "#f9e2af"; };
          off = { fg = "#6c7086"; };
          title = { fg = "#89b4fa"; bold = true; };
          command = { fg = "#f5c2e7"; bold = true; };
          key = { fg = "#a6e3a1"; bold = true; };
          match = { fg = "#f38ba8"; };
        };
      };
    };

    # Key bindings
    keymap = {
      # General
      manager.prepend_keymap = [
        { on = [ "g" "h" ]; run = "cd ~"; desc = "Go to home directory"; }
        { on = [ "g" "d" ]; run = "cd ~/Downloads"; desc = "Go to Downloads"; }
        { on = [ "g" "c" ]; run = "cd ~/.config"; desc = "Go to config"; }
      ];
    };
  };

  # Install dependencies
  home.packages = with pkgs; [
    mpv # Video player
    file # File type detection
  ];
}
