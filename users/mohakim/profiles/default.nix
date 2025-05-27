# Default profile for mohakim
{ config, pkgs, lib, ... }:

{
  imports = [
    # Import the personal profile
    ./personal.nix

    # You can add other profiles here and toggle them as needed
    # ./work.nix
  ];

  # Common configuration across all profiles
  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    TERMINAL = "alacritty";
    BROWSER = "librewolf";
  };

  # Enable font configuration
  fonts.fontconfig.enable = true;

  # Common packages used across all profiles
  home.packages = with pkgs; [
    # Essential CLI tools
    ripgrep # Better grep
    fd # Better find
    bat # Better cat
    eza # Better ls
    fzf # Fuzzy finder
    pandoc

    # System monitoring
    btop # Better top

    # Compression
    zip
    unzip
    p7zip

    # Fonts
    nerd-fonts.jetbrains-mono
  ];

  # Git configuration used across all profiles
  programs.git = {
    enable = true;
    userName = "mohakim";
    userEmail = "m.abdihakim@proton.me"; # Replace with your actual email

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };

    delta = {
      enable = true;
      options = {
        line-numbers = true;
        side-by-side = true;
        syntax-theme = "Monokai Extended";
      };
    };
  };
}
