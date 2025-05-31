{ config, lib, ... }:

with lib;
let
  cfg = config.modules.gamescope;
in
{
  options.modules.gamescope = {
    enable = mkEnableOption "Gamescope with Wayland+Vulkan";
  };

  config = mkIf cfg.enable {
    programs.gamescope = {
      enable = true;
      capSysNice = true;
      args = [ "--rt" ];
      env = {
        "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
        "VK_LOADER_DEBUG" = "all";
        "SDL_VIDEODRIVER" = "wayland,x11";
      };
    };
  };
}
