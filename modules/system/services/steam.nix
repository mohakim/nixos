# modules/system/services/steam.nix
{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.services.steam;
in
{
  options.modules.services.steam = {
    enable = mkEnableOption "Enable Steam with Wayland optimizations";

    useGamescope = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to use Gamescope with Steam";
    };
  };

  config = mkIf cfg.enable {
    # Enable Steam
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = cfg.useGamescope;

      # Only include Steam-specific environment tweaks
      package = pkgs.steam.override {
        extraProfile = ''
          # Steam-specific optimizations only (not duplicating system variables)
          export STEAM_DISABLE_MANGOAPP=1
          export DXVK_ASYNC=1
          export RADV_PERFTEST=aco
          
          # Steam controller support
          export SDL_GAMECONTROLLERCONFIG_FILE=/etc/steam-controller-config.txt
        '';
      };
    };

    # Enable Gamemode for better performance
    programs.gamemode.enable = true;

    # Steam-specific dependencies
    environment.systemPackages = with pkgs; [
      mangohud
      gamemode
    ];

    # Create controller configuration
    environment.etc."steam-controller-config.txt".text = "";
  };
}
