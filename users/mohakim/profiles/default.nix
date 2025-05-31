# Default profile for mohakim
{ pkgs, ... }:

{
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
    ripgrep
    fd
    bat
    eza
    fzf
    pandoc
    bottom
    ouch
    rustup

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
