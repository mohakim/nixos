# hosts/nixos/default.nix
{ config, pkgs, lib, niri, username, ... }:

{
  imports = [
    # Include hardware configuration
    ./hardware-configuration.nix

    # Import system modules
    ../../modules/system/desktop/niri.nix
    ../../modules/system/desktop/nvidia.nix
    ../../modules/system/desktop/keyd.nix
    ../../modules/system/services/bluetooth.nix
    ../../modules/system/services/steam.nix
    ../../modules/system/services/gamescope.nix
    ../../modules/system/services/virtualization.nix
  ];

  # Host-specific configuration
  networking.hostName = "nixos";

  # Enable all modules in a clean, non-redundant way
  modules = {
    desktop = {
      niri.enable = true;
      niri.package = pkgs.niri-stable;
      nvidia.enable = true;
      keyd.enable = true;
    };
    services = {
      bluetooth.enable = true;
      steam = {
        enable = true;
        useGamescope = true;
      };
      gamescope.enable = true;
      virtualization.enable = true;
    };
  };

  # Hardware configuration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Any additional system packages specific to this host
  environment.systemPackages = with pkgs; [
    # Media codecs and base utilities
    wireplumber
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];
}
