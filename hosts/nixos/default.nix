# Main system configuration for nixos host
{ config, pkgs, lib, niri, username, ... }:

{
  imports = [
    # Include hardware configuration
    ./hardware-configuration.nix

    # Import system modules
    ../../modules/system/desktop/niri.nix
    ../../modules/system/desktop/nvidia.nix
    ../../modules/system/desktop/keyd.nix
    ../../modules/system/desktop/xwayland.nix
    ../../modules/system/services/bluetooth.nix
    ../../modules/system/services/steam.nix
  ];

  # Host-specific configuration
  networking.hostName = "nixos";


  # Enable all desktop modules
  modules = {
    desktop = {
      niri = {
        enable = true;
        package = pkgs.niri-stable;
      };
      nvidia.enable = true;
      keyd.enable = true;
      xwayland.enable = true;
    };
    services = {
      bluetooth.enable = true;
      steam.enable = true;
    };
  };

  # Hardware configuration specific to this machine
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Any additional system packages specific to this host
  environment.systemPackages = with pkgs; [
    # Host-specific packages
    wireplumber
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    wl-gammarelay-rs
    xwayland-satellite
    swww
  ];
}
