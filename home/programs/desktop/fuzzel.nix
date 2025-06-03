# Fuzzel application launcher configuration
{ pkgs, ... }:

{
  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=14";
        terminal = "${pkgs.alacritty}/bin/alacritty";
        dpi-aware = "auto";
        prompt = "❯   ";
        icon-theme = "Papirus-Dark";
      };

      colors = {
        background = "1e1e2eff";
        text = "cdd6f4ff";
        match = "f38ba8ff";
        selection = "89b4faff";
        selection-text = "1e1e2eff";
        border = "89b4faff";
      };

      border = {
        width = 3;
        radius = 8;
      };
    };
  };
}
