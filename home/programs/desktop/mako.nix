{ pkgs, ... }:

{
  services.mako = {
    enable = true;
    settings = {
      # Basic configuration
      font = "JetBrainsMono Nerd Font 11";
      width = 400;
      height = 120;
      margin = "20";
      padding = "15,20";
      border-size = 2;
      border-radius = 8;

      # Catppuccin Mocha colors
      background-color = "#1e1e2e";
      text-color = "#cdd6f4";
      border-color = "#89b4fa";
      progress-color = "over #313244";

      # Positioning and behavior
      anchor = "top-right";
      max-visible = 5;
      sort = "-time";
      layer = "overlay";
      default-timeout = 5000;
      ignore-timeout = false;

      # Features
      markup = true;
      actions = true;
      history = true;
      text-alignment = "left";
      max-icon-size = 48;
      group-by = "app-name";
    };
  };

  home.packages = with pkgs; [
    libnotify # for notify-send testing
  ];
}
