# Common system-wide configuration shared across all hosts
{ config, pkgs, lib, ... }:

{
  # Enable flakes and the new nix command
  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      warn-dirty = false;
    };

    # Garbage collection settings
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Bootloader configuration
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 5;
  };

  # Set timezone to Kuala Lumpur
  time.timeZone = "Asia/Kuala_Lumpur";

  # Networking defaults
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowPing = true;
    };
  };

  # XDG portals for Wayland
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Sound with PipeWire
  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable common services
  services = {
    # Display manager
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "niri --session";
          user = "mohakim";
        };
      };
    };

    # Time synchronization
    timesyncd.enable = true;
  };

  # System-wide environment variables
  environment.sessionVariables = {
    "NIXOS_OZONE_WL" = "1";
    "NIXOS_CONFIG_DIR" = "$HOME/.config/nixos";
  };

  # Common system packages
  environment.systemPackages = with pkgs; [
    # Basic utilities that should be available on all systems
    git
    wget
    curl
    pciutils
    usbutils
    file
    gnupg
    home-manager
  ];

  # Enable fish shell system-wide
  programs.fish.enable = true;
  programs.command-not-found.enable = false;

  # Keep state version fixed
  system.stateVersion = "23.11";
}
