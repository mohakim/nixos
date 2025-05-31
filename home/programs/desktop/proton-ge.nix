{ pkgs, ... }:

{
  home.packages = [ pkgs.proton-ge-custom ];

  home.file = {
    # Create Steam compatibility tools directory
    ".steam/root/compatibilitytools.d".source =
      "${pkgs.proton-ge-custom}/share/steam/compatibilitytools.d";

    # Steam settings for Proton
    ".local/share/Steam/steamapps/common/SteamLinuxRuntime_sniper/share/default_sniper_config".text = ''
      # Proton Settings
      STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.steam/steam"
      STEAM_COMPAT_DATA_PATH="$HOME/.steam/steam/steamapps/compatdata"
      
      # Hardware acceleration
      RADV_PERFTEST=aco
      
      # Gamemode integration
      STEAM_RUNTIME_PREFER_HOST_LIBRARIES=0
      LD_PRELOAD=/usr/\$LIB/libgamemodeauto.so
    '';
  };

  # Gaming optimizations service
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
}
