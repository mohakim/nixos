# Desktop environment configuration for mohakim
{ config, pkgs, lib, ... }:

{
  imports = [
    # Import specific desktop configurations
    ./proton-ge.nix

    # Import home-manager modules for desktop
    ../../../../modules/home/desktop/alacritty.nix
    ../../../../modules/home/desktop/mako.nix
    ../../../../modules/home/desktop/wl-gammarelay.nix
    ../../../../modules/home/desktop/niri.nix
    ../../../../modules/home/desktop/wasistlos.nix
  ];

  # Enable the desktop modules you want
  custom = {
    desktop = {
      mako.enable = true;
      whatsapp.enable = true;
      alacritty.enable = true;
      wl-gammarelay.enable = true;
      proton-ge.enable = true;
    };
  };

  # Common desktop packages
  home.packages = with pkgs; [
    fuzzel
    krita
    obsidian
    element-desktop
    swww
    grim
    slurp
    wl-clipboard
    webcord
    librewolf
    nerd-fonts.jetbrains-mono
  ];

  # Set default applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/io.element.desktop" = "element-desktop.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
      "application/pdf" = "librewolf.desktop";
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
