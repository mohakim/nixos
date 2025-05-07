# Personal profile configuration
{ config, pkgs, lib, ... }:

{
  # Personal packages
  home.packages = with pkgs; [
    # Creative applications
    krita # Image editor
    obsidian # Note-taking

    # Communication
    element-desktop # Matrix client

    # Utilities
    swww # Wallpaper manager
    wl-gammarelay-rs # Blue light filter

    # Development
    rustup # Rust toolchain
  ];

  # SSH configuration
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        extraOptions = {
          AddKeysToAgent = "yes";
          IdentityFile = "~/.ssh/id_ed25519";
        };
      };
      # Add your frequent SSH destinations here
      # "github.com" = {
      #   hostname = "github.com";
      #   user = "git";
      # };
    };
  };

  # Custom file associations
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/plain" = [ "helix.desktop" ];
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      "text/html" = [ "librewolf.desktop" ];
      "x-scheme-handler/http" = [ "librewolf.desktop" ];
      "x-scheme-handler/https" = [ "librewolf.desktop" ];
    };
  };

  # GPG configuration for signing
  programs.gpg = {
    enable = true;
    settings = {
      default-key = "YOUR_KEY_ID"; # Replace with your key ID
    };
  };

  # Custom keybindings and other personal preferences can go here
}
