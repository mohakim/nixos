{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.keyd;
in
{
  options.modules.keyd = {
    enable = mkEnableOption "keyd key remapping daemon";
  };

  config = mkIf cfg.enable {
    services.keyd = {
      enable = true;
      keyboards.default = {
        settings = {
          ids."*" = "";
          main = {
            capslock = "C-g";
            alt = "layer(alt)";
          };
          alt = {
            j = "left";
            i = "up";
            l = "right";
            k = "down";
            backspace = "delete";
            u = "home";
            o = "end";
          };
          "alt:C" = { };
        };
      };
    };

    environment.systemPackages = [ pkgs.keyd ];
  };
}
