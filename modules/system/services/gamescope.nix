# modules/system/services/gamescope.nix
{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.services.gamescope;
in
{
  options.modules.services.gamescope = {
    enable = mkEnableOption "Enable Gamescope with Wayland+Vulkan";
  };

  config = mkIf cfg.enable {
    # Enable gamescope with simplified settings
    programs.gamescope = {
      enable = true;
      capSysNice = true;

      # Simplified args known to work with NVIDIA
      args = [
        "--rt"
      ];

      # Critical environment variables - explicitly set to override any global settings
      env = {
        # Force NVIDIA Vulkan ICD explicitly
        "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
        # Enable Vulkan debugging
        "VK_LOADER_DEBUG" = "all";
        # Wayland and SDL config
        "SDL_VIDEODRIVER" = "wayland,x11";
      };
    };

    # # Create test script for Gamescope + NVIDIA
    # environment.systemPackages = with pkgs; [
    #   (writeShellScriptBin "fix-nvidia-gamescope" ''
    #     #!/usr/bin/env bash
    #     # Script to fix NVIDIA + Gamescope compatibility

    #     # Find the correct NVIDIA ICD file
    #     NVIDIA_PATH="${config.hardware.nvidia.package.out}"
    #     ICD_PATH="$NVIDIA_PATH/share/vulkan/icd.d/nvidia_icd.json"

    #     # Check if it exists
    #     if [ ! -f "$ICD_PATH" ]; then
    #       echo "ERROR: NVIDIA Vulkan ICD file not found at: $ICD_PATH"
    #       echo "Looking for alternatives..."
    #       find /nix/store -name "nvidia_icd.json" | grep -v i686
    #       exit 1
    #     fi

    #     # Set environment variables
    #     export VK_ICD_FILENAMES="$ICD_PATH"
    #     export __GLX_VENDOR_LIBRARY_NAME=nvidia
    #     export SDL_VIDEODRIVER=wayland,x11

    #     # Debug info
    #     echo "Using NVIDIA Vulkan ICD: $ICD_PATH"
    #     echo "Running: gamescope -W 800 -H 600 --force-windows-fullscreen $@"

    #     # Run gamescope with basic settings
    #     gamescope -W 800 -H 600 --force-windows-fullscreen -- "$@"
    #   '')
    # ];
  };
}
