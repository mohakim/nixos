{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.nvidia;
in
{
  options.modules.nvidia = {
    enable = mkEnableOption "NVIDIA driver optimized for Wayland";
    package = mkOption {
      type = types.package;
      default = config.boot.kernelPackages.nvidiaPackages.beta;
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
      open = false;
      nvidiaSettings = true;
      forceFullCompositionPipeline = false;
    };

    # Hardware acceleration (moved from configuration.nix)
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver # NVIDIA hardware video acceleration
        vaapiVdpau # VAAPI to VDPAU bridge
        libvdpau-va-gl # VDPAU OpenGL backend
      ];
    };

    # NVIDIA and graphics-related packages
    environment.systemPackages = with pkgs; [
      vulkan-loader
      vulkan-tools
      vulkan-validation-layers
      wayland-protocols
    ];

    # Create shader cache directory
    systemd.tmpfiles.rules = [
      "d /tmp/nvidia-shader-cache 0755 - - -"
    ];
  };
}
