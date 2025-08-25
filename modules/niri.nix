{ config, pkgs, lib, niri, ... }:

with lib;
let
  cfg = config.modules.niri;
in
{
  options.modules.niri = {
    enable = mkEnableOption "Niri window manager";
    package = mkOption {
      type = types.package;
      default = niri.packages.${pkgs.system}.niri-stable;
      description = "The Niri package to use";
    };
  };

  config = mkIf cfg.enable {
    programs.niri = {
      enable = true;
      package = cfg.package;
    };
  };
}
