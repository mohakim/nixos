# Bluetooth configuration
{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.services.bluetooth;
in
{
  options.modules.services.bluetooth = {
    enable = mkEnableOption "Enable Bluetooth support";

    powerOnBoot = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to power on Bluetooth adapters at boot";
    };

    experimental = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable experimental features";
    };
  };

  config = mkIf cfg.enable {
    # Enable bluetooth service
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = cfg.powerOnBoot;
      settings = {
        General = {
          Experimental = cfg.experimental;
          KernelExperimental = cfg.experimental;
        };
      };
    };

    # Install bluetooth packages
    environment.systemPackages = with pkgs; [
      bluez
      bluez-tools
      bluetui
    ];
  };
}
