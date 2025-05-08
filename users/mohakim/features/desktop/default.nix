# Desktop environment configuration for mohakim
{ config, pkgs, lib, ... }:

{
  imports = [
    # Import specific desktop configurations
    ./proton-ge.nix

    # Import home-manager modules for desktop
    ../../../../modules/home/desktop/alacritty.nix
    ../../../../modules/home/desktop/wl-gammarelay.nix
    ../../../../modules/home/desktop/niri.nix
  ];

  # Enable the desktop modules you want
  custom = {
    desktop = {
      alacritty.enable = true;
      wl-gammarelay.enable = true;
      proton-ge.enable = true;
    };
  };

  # Common desktop packages
  home.packages = with pkgs; [
    fuzzel
    swww
    grim
    slurp
    wl-clipboard
    librewolf
    catppuccin-gtk
    papirus-icon-theme
    nerd-fonts.jetbrains-mono
  ];

  # GTK configuration
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        size = "standard";
        tweaks = [ "rimless" "black" ];
        variant = "mocha";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # Cursor theme
  home.pointerCursor = {
    name = "Catppuccin-Mocha-Dark-Cursors";
    package = pkgs.catppuccin-cursors.mochaDark;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Set default applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
      "application/pdf" = "org.pwmt.zathura.desktop";
      "image/png" = "imv.desktop";
      "image/jpeg" = "imv.desktop";
      "image/gif" = "imv.desktop";
      "image/svg+xml" = "imv.desktop";
      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "audio/mp3" = "mpv.desktop";
      "audio/flac" = "mpv.desktop";
      "audio/wav" = "mpv.desktop";
    };
  };

  # Fuzzel application launcher config
  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    [main]
    font=JetBrainsMono Nerd Font:size=14
    terminal=alacritty
    dpi-aware=auto
    prompt="❯   "
    icon-theme=Papirus-Dark
    
    [colors]
    background=1e1e2eff
    text=cdd6f4ff
    match=f38ba8ff
    selection=89b4faff
    selection-text=1e1e2eff
    border=89b4faff
    
    [border]
    width=3
    radius=8
  '';
}
