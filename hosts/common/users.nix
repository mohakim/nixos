# User configuration for all hosts
{ pkgs, username, ... }:

{
  # Default user account settings
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [
      "networkmanager"
      "wheel" # Enable sudo
      "video" # For screen brightness, etc.
      "audio" # For audio controls
      "input" # For input devices
      "libvirtd" # For virtual machine management
    ];
    shell = pkgs.fish;
    uid = 1000; # Include the UID in the original definition
  };

  # Use sudo for privilege escalation
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };

  # Enable password authentication
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
