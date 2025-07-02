{ pkgs, lib, ... }:

{
  imports = [
    ./modules/bluetooth.nix
    ./modules/gamescope.nix
    ./modules/keyd.nix
    ./modules/niri.nix
    ./modules/nvidia.nix
    ./modules/steam.nix
  ];

  # Nix configuration
  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      warn-dirty = false;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 4d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Boot configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 5;
    };
    kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia.NVreg_UsePageAttributeTable=1"
      "nvidia.NVreg_EnablePCIeGen3=1"
    ];
  };

  # System basics
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowPing = true;
    };
  };

  time.timeZone = "Asia/Kuala_Lumpur";

  # User configuration
  users.users.mohakim = {
    isNormalUser = true;
    description = "mohakim";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
      "input"
      "libvirtd"
    ];
    shell = pkgs.fish;
    uid = 1000;
  };

  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = true;
    };
    rtkit.enable = true;
    polkit.enable = true;
    pam.loginLimits = [
      { domain = "*"; type = "soft"; item = "memlock"; value = "unlimited"; }
      { domain = "*"; type = "hard"; item = "memlock"; value = "unlimited"; }
    ];
  };

  # Audio with PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Display manager
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "niri --session";
      user = "mohakim";
    };
  };

  # XDG portals for Wayland
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # SSH configuration
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.timesyncd.enable = true;

  # Consolidated environment variables
  environment = {
    sessionVariables = {
      # Nix configuration
      "NIXOS_CONFIG_DIR" = "$HOME/.config/nixos";

      # Wayland environment
      "NIXOS_OZONE_WL" = "1";
      "MOZ_ENABLE_WAYLAND" = "1";
      "XDG_CURRENT_DESKTOP" = "niri";
      "XDG_SESSION_TYPE" = "wayland";
      "QT_QPA_PLATFORM" = "wayland";

      # NVIDIA specific variables
      "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
      "LIBVA_DRIVER_NAME" = "nvidia";
      "GBM_BACKEND" = "nvidia-drm";
      "WLR_RENDERER" = "vulkan";
      "WLR_NO_HARDWARE_CURSORS" = "1";
      "NVD_BACKEND" = "direct";

      # Vulkan
      "VK_ICD_FILENAMES" = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";
      "VK_LAYER_PATH" = "/run/opengl-driver/share/vulkan/explicit_layer.d";
    };

    variables = {
      "XDG_DATA_DIRS" = lib.mkForce [ "/run/opengl-driver/share" ];
    };

    systemPackages = with pkgs; [
      git
      curl
      file
      gnupg
      home-manager
    ];
  };

  services.udev.extraRules = ''
    # Wooting One Legacy
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", TAG+="uaccess"

    # Wooting One update mode
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2402", TAG+="uaccess"

    # Wooting Two Legacy
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", TAG+="uaccess"

    # Wooting Two update mode
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2403", TAG+="uaccess"

    # Generic Wooting devices (covers 60HE+ and all newer models)
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", TAG+="uaccess"
  '';

  # Enable programs
  programs = {
    fish.enable = true;
    command-not-found.enable = false;
  };

  # Enable modules
  modules = {
    bluetooth.enable = true;
    gamescope.enable = true;
    keyd.enable = true;
    niri.enable = true;
    nvidia.enable = true;
    steam = {
      enable = true;
      useGamescope = true;
    };
  };

  system.stateVersion = "23.11";
}
