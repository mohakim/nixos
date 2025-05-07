# keyd key remapping daemon configuration
{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.desktop.keyd;
in
{
  options.modules.desktop.keyd = {
    enable = mkEnableOption "Enable keyd key remapping daemon";

    configuration = mkOption {
      type = types.lines;
      default = ''
        [ids]
        *

        [main]
        alt = layer(alt)

        [alt]
        j = left
        i = up
        l = right
        k = down
        backspace = delete
        u = home
        o = end

        [alt:C]
      '';
      description = "The keyd configuration content";
    };
  };

  config = mkIf cfg.enable {
    # Enable the keyd service
    services.keyd = {
      enable = true;
    };

    # Create a configuration file directly in the correct location
    environment.etc."keyd/default.conf".text = cfg.configuration;

    # Install keyd package
    environment.systemPackages = with pkgs; [
      keyd
    ];
  };
}
