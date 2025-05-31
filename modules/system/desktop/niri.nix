# System-wide Niri configuration
{ config, pkgs, lib, niri, ... }:
let
  cfg = config.modules.desktop.niri;
in
{
  options.modules.desktop.niri = {
    enable = lib.mkEnableOption "Enable Niri";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.niri-stable;
      description = "The Niri package to use";
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [ niri.overlays.niri ];
    programs.niri = {
      enable = true;
      package = cfg.package;
    };
  };
}
