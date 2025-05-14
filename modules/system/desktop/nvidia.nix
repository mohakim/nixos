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

    # # Enable OpenGL and hardware acceleration - CRITICAL FIX
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      # driSupport = true;
      # driSupport32Bit = true;
      # These make sure the right Vulkan drivers are available
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    # Global environment variables - CRITICAL FIX
    environment.variables = {
      # CORRECT VULKAN ICD PATH - don't use libGLX_nvidia.so
      # "VK_ICD_FILENAMES" = "${config.hardware.nvidia.package.out}/share/vulkan/icd.d/nvidia_icd.x86_64.json";
      "VK_ICD_FILENAMES" = "/nix/store/3bg1kk8w74rnvax06xkii90ni7jx5l1k-nvidia-x11-570.144-6.12.26/share/vulkan/icd.d/nvidia_icd.x86_64.json";

      # Rest of your variables...
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

    # system.activationScripts.nvidia-vulkan-permissions = ''
    #   if [ -e ${config.hardware.nvidia.package.out}/share/vulkan/icd.d/nvidia_icd.x86_64.json ]; then
    #     chmod +r ${config.hardware.nvidia.package.out}/share/vulkan/icd.d/nvidia_icd.x86_64.json
    #   fi
    # '';

    environment.sessionVariables = {
      # Supplementary Vulkan registry paths
      "XDG_DATA_DIRS" = [ "/run/opengl-driver/share" "${config.hardware.nvidia.package.out}/share" ];
    };

    # Required packages
    environment.systemPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
      vulkan-extension-layer
      wayland
      wayland-utils
      wayland-protocols
      # mesa-utils
    ];
  };
}
