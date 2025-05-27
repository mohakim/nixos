# Virtualization services (QEMU/KVM + virt-manager)
{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.modules.services.virtualization;
in
{
  options.modules.services.virtualization = {
    enable = mkEnableOption "Enable virtualization support with QEMU/KVM and virt-manager";

    enableGUI = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to install virt-manager GUI";
    };

    enableSpice = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable SPICE protocol support";
    };

    enableOVMF = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable UEFI support for VMs";
    };
  };

  config = mkIf cfg.enable {
    # Enable KVM virtualization
    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm.enable = true;
          ovmf = mkIf cfg.enableOVMF {
            enable = true;
            packages = [ pkgs.OVMFFull.fd ];
          };
        };
      };

      # Enable SPICE USB redirection
      spiceUSBRedirection.enable = cfg.enableSpice;
    };

    # Install virtualization packages
    environment.systemPackages = with pkgs; [
      qemu_kvm
      qemu-utils
    ] ++ optionals cfg.enableGUI [
      virt-manager
      virt-viewer
    ] ++ optionals cfg.enableSpice [
      spice
      spice-gtk
      spice-protocol
      win-virtio
    ];

    # Enable virt-manager for GUI users
    programs.virt-manager.enable = cfg.enableGUI;
  };
}
