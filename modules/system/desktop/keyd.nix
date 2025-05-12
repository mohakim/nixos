# keyd key remapping daemon configuration
{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.desktop.keyd;
in
{
  options.modules.desktop.keyd = {
    enable = mkEnableOption "Enable keyd key remapping daemon";
  };

  config = mkIf cfg.enable {
    # Enable the keyd service
    services.keyd = {
      enable = true;
      keyboards.default = {
        settings = {
          # INI format requires sections with key-value pairs
          ids = {
            "*" = ""; # Empty string for a wildcard match
          };

          main = {
            capslock = "C-g"; # Map capslock to Ctrl+g for Zellij unlock
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

          "alt:C" = { }; # Empty section
        };
      };
    };

    # Install keyd package
    environment.systemPackages = with pkgs; [
      keyd
    ];
  };
}
