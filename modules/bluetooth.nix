{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.bluetooth;
in
{
  options.modules.bluetooth = {
    enable = mkEnableOption "Bluetooth support";
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General = {
        Experimental = true;
        KernelExperimental = true;
      };
    };

    environment.systemPackages = with pkgs; [
      bluez
      bluez-tools
      bluetui
    ];
  };
}
