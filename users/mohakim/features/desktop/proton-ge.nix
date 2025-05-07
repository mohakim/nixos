# Proton GE configuration for Steam
{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.custom.desktop.proton-ge;
in
{
  options.custom.desktop.proton-ge = {
    enable = mkEnableOption "Enable Proton GE for Steam";

    manageSteamSettings = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to manage Steam settings for Proton";
    };

    createSymlinks = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to create compatibility tool symlinks in Steam";
    };
  };

  config = mkIf cfg.enable {
    # Make Proton GE available
    home.packages = with pkgs; [
      # Use a direct reference from pkgs to ensure the overlay is applied
      pkgs.proton-ge-custom
    ];

    # Create the Steam compatibility tools directory
    home.file = mkMerge [
      (mkIf cfg.createSymlinks {
        ".steam/root/compatibilitytools.d".source =
          "${pkgs.proton-ge-custom}/share/steam/compatibilitytools.d";
      })

      (mkIf cfg.manageSteamSettings {
        ".local/share/Steam/steamapps/common/SteamLinuxRuntime_sniper/share/default_sniper_config".text = ''
          # Proton Settings
          STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.steam/steam"
          STEAM_COMPAT_DATA_PATH="$HOME/.steam/steam/steamapps/compatdata"
          
          # Hardware acceleration
          RADV_PERFTEST=aco
          VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json
          
          # Enable FSR
          WINE_FULLSCREEN_FSR=1
          WINE_FULLSCREEN_FSR_STRENGTH=3
          
          # Gamemode integration
          STEAM_RUNTIME_PREFER_HOST_LIBRARIES=0
          LD_PRELOAD=/usr/\$LIB/libgamemodeauto.so
          
          # Wayland compatibility
          SDL_VIDEODRIVER=x11
        '';
      })
    ];

    # Gaming optimizations
    systemd.user.services.gamemode = {
      Unit = {
        Description = "Gamemode - optimizes system performance on demand";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.gamemode}/bin/gamemoded -f";
        Restart = "always";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
