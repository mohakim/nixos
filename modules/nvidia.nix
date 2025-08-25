{ config, lib, ... }:

with lib;
let
  cfg = config.modules.nvidia;
in
{
  options.modules.nvidia = {
    enable = mkEnableOption "NVIDIA driver optimized for Wayland";
    package = mkOption {
      type = types.package;
      default = config.boot.kernelPackages.nvidiaPackages.stable;
      description = "The NVIDIA driver package to use";
    };
  };

  config = mkIf cfg.enable {
    # Enable NVIDIA driver
    services.xserver.videoDrivers = [ "nvidia" ];

    # NVIDIA hardware configuration
    hardware.nvidia = {
      package = cfg.package;
      modesetting.enable = true;
      powerManagement.enable = false;
      open = true;
    };

    # Hardware acceleration (moved from configuration.nix)
    hardware.graphics = {
      enable = true;
    };
  };
}
