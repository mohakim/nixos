# modules/system/desktop/nvidia-wayland.nix
{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.desktop.nvidia-wayland;
in
{
  options.modules.desktop.nvidia-wayland = {
    enable = mkEnableOption "Enable NVIDIA driver optimized for Wayland";

    package = mkOption {
      type = types.package;
      default = config.boot.kernelPackages.nvidiaPackages.stable;
      description = "The NVIDIA driver package to use";
    };
  };

  config = mkIf cfg.enable {
    # Enable NVIDIA driver
    services.xserver.videoDrivers = [ "nvidia" ];
    boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
    boot.blacklistedKernelModules = [ "nouveau" ];

    # Critical kernel parameter for Wayland
    boot.kernelParams = [ "nvidia-drm.modeset=1" ];

    # Configure NVIDIA hardware
    hardware.nvidia = {
      package = cfg.package;
      modesetting.enable = true;
      powerManagement.enable = false;
      open = false;
      nvidiaSettings = true;
      forceFullCompositionPipeline = true;
    };

    # Global environment variables for Wayland + NVIDIA
    environment.variables = {
      # Vulkan configuration
      "VK_ICD_FILENAMES" = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json";

      # NVIDIA-specific settings
      "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
      "LIBVA_DRIVER_NAME" = "nvidia";
      "GBM_BACKEND" = "nvidia-drm";
      "WLR_RENDERER" = "vulkan";
      "NVD_BACKEND" = "direct";
      "WLR_NO_HARDWARE_CURSORS" = "1";

      # Pure Wayland settings
      "MOZ_ENABLE_WAYLAND" = "1";
      "NIXOS_OZONE_WL" = "1";
      "XDG_SESSION_TYPE" = "wayland";
      "QT_QPA_PLATFORM" = "wayland";
    };

    # Make sure OpenGL and Vulkan are properly configured
    # hardware.nvidia = {
    #   enable = true;
    #   enable32Bit = true;
    #   extraPackages = with pkgs; [
    #     nvidia-vaapi-driver
    #     vaapiVdpau
    #   ];
    # };

    # Required Vulkan packages
    environment.systemPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
      vulkan-extension-layer
    ];
  };
}
