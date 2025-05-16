# modules/system/desktop/nvidia.nix
{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.desktop.nvidia;
in
{
  options.modules.desktop.nvidia = {
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

    # Critical kernel parameter for Wayland
    boot.kernelParams = [
      "nvidia-drm.modeset=1"
      # Add these new parameters for better memory handling
      "nvidia.NVreg_UsePageAttributeTable=1"
      "nvidia.NVreg_EnablePCIeGen3=1"
    ];

    # Configure NVIDIA hardware
    hardware.nvidia = {
      package = cfg.package;
      modesetting.enable = true;
      powerManagement.enable = false;
      open = false;
      nvidiaSettings = true;
      forceFullCompositionPipeline = true;
    };

    # Fix locked memory limit for GPU operations
    security.pam.loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "memlock";
        value = "unlimited";
      }
      {
        domain = "*";
        type = "hard";
        item = "memlock";
        value = "unlimited";
      }
    ];

    # Rest of your existing configuration...
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    environment.variables = {
      "VK_ICD_FILENAMES" = "/nix/store/3bg1kk8w74rnvax06xkii90ni7jx5l1k-nvidia-x11-570.144-6.12.26/share/vulkan/icd.d/nvidia_icd.x86_64.json";
      "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
      "LIBVA_DRIVER_NAME" = "nvidia";
      "GBM_BACKEND" = "nvidia-drm";
      "WLR_RENDERER" = "vulkan";
      "NVD_BACKEND" = "direct";
      "WLR_NO_HARDWARE_CURSORS" = "1";
      "MOZ_ENABLE_WAYLAND" = "1";
      "NIXOS_OZONE_WL" = "1";
      "XDG_SESSION_TYPE" = "wayland";
      "QT_QPA_PLATFORM" = "wayland";
    };

    environment.sessionVariables = {
      "XDG_DATA_DIRS" = [ "/run/opengl-driver/share" "${config.hardware.nvidia.package.out}/share" ];
    };

    environment.systemPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
      vulkan-extension-layer
      wayland
      wayland-utils
      wayland-protocols
    ];
  };
}
