# NVIDIA configuration module
{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.desktop.nvidia;
in
{
  options.modules.desktop.nvidia = {
    enable = mkEnableOption "Enable NVIDIA driver configuration";

    package = mkOption {
      type = types.package;
      default = config.boot.kernelPackages.nvidiaPackages.stable;
      description = "The NVIDIA driver package to use";
    };

    open = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to use the open source parts of the driver";
    };

    powerManagement = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable NVIDIA power management";
      };

      finegrained = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to use fine-grained power management";
      };
    };
  };

  config = mkIf cfg.enable {
    # Enable graphics
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # NVIDIA driver configuration
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = cfg.powerManagement.enable;
      powerManagement.finegrained = cfg.powerManagement.finegrained;
      open = cfg.open;
      nvidiaSettings = true;
      package = cfg.package;
    };

    # NVIDIA-specific environment variables
    environment.sessionVariables = {
      "LIBVA_DRIVER_NAME" = "nvidia";
      "XDG_SESSION_TYPE" = "wayland";
      "GBM_BACKEND" = "nvidia-drm";
      "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
      "WLR_NO_HARDWARE_CURSORS" = "1";
    };
  };
}
