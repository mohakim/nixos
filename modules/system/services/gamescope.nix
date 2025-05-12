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
    # Enable standard NixOS gamescope module with optimized settings
    programs.gamescope = {
      enable = true;
      capSysNice = false; # Keep false for NVIDIA compatibility

      # Core arguments for optimal performance
      args = [
        "--rt" # Use realtime priority rendering
        "--force-direct-composition" # Force direct composition mode
        "--hdr-enabled" # Enable HDR support
      ];
    };

    # Instead of using the env option, we'll apply environment variables system-wide
    # This avoids the wrapping error while still ensuring the variables are available
    environment.variables = {
      "GAMESCOPE_FORCE_DIRECT_VULKAN_DEVICE" = "1";
      "GAMESCOPE_RT_COMPOSITOR" = "1";
      "VK_LOADER_LAYERS_ENABLE" = "*_WAYLAND_*";
      "ENABLE_VKBASALT" = "1";
    };

    # Only include packages specific to Gamescope
    environment.systemPackages = with pkgs; [
      gamescope
      wl-gammarelay-rs
      swww
    ];

    # Create a simplified launch script
    environment.etc."run-gamescope.sh" = {
      mode = "0755";
      text = ''
        #!/bin/sh
        gamescope -W 2560 -H 1440 -r 165 -f \
          --rt --force-direct-composition \
          --prefer-output DP-2 \
          --adaptive-sync \
          -- "$@"
      '';
    };
  };
}
