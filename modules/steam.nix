{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.steam;
in
{
  options.modules.steam = {
    enable = mkEnableOption "Steam with Wayland optimizations";
    useGamescope = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to use Gamescope with Steam";
    };
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = cfg.useGamescope;
      package = pkgs.steam.override {
        extraProfile = ''
          export STEAM_DISABLE_MANGOAPP=1
          export DXVK_ASYNC=1
          export RADV_PERFTEST=aco
          export SDL_GAMECONTROLLERCONFIG_FILE=/etc/steam-controller-config.txt
        '';
      };
    };

    programs.gamemode.enable = true;

    environment = {
      systemPackages = with pkgs; [ mangohud gamemode ];
      etc."steam-controller-config.txt".text = "";
    };
  };
}
