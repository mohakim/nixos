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

        image = [
          { run = "imv \"$@\""; block = false; }
        ];

        video = [
          { run = "mpv \"$@\""; block = false; }
        ];

        audio = [
          { run = "mpv \"$@\""; block = false; }
        ];

        pdf = [
          { run = "zathura \"$@\""; block = false; }
        ];

        archive = [
          # Correct format for the archive opener with proper escaping
          {
            run = ''sh -c 'mkdir -p "''${1%%.*}" && tar -xf "$1" -C "''${1%%.*}"'';
            block = true;
          }
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
        { on = [ "h" ]; run = "parent"; desc = "Go to parent directory"; }
        { on = [ "j" ]; run = "arrow down"; desc = "Move cursor down"; }
        { on = [ "k" ]; run = "arrow up"; desc = "Move cursor up"; }
        { on = [ "l" ]; run = "open"; desc = "Open file"; }
        { on = [ "g" "h" ]; run = "cd ~"; desc = "Go to home directory"; }
        { on = [ "g" "d" ]; run = "cd ~/Downloads"; desc = "Go to Downloads"; }
        { on = [ "g" "c" ]; run = "cd ~/.config"; desc = "Go to config"; }
        { on = [ "g" "j" ]; run = "arrow bottom"; desc = "Go to bottom"; }
        { on = [ "g" "k" ]; run = "arrow top"; desc = "Go to top"; }
        { on = [ "space" ]; run = "select --toggle=true"; desc = "Toggle selection"; }
        { on = [ "d" "d" ]; run = "trash"; desc = "Move to trash"; }
        { on = [ "y" "y" ]; run = "copy path"; desc = "Copy path"; }
        { on = [ "y" "n" ]; run = "copy name"; desc = "Copy name"; }
        { on = [ "c" "w" ]; run = "clear selections"; desc = "Clear selections"; }
      ];
    };
  };

  # Install dependencies
  home.packages = with pkgs; [
    imv # Image viewer
    mpv # Video player
    zathura # PDF viewer
    file # File type detection
    ffmpegthumbnailer # Video thumbnails
    poppler # PDF thumbnails
  ];
}
