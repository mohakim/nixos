# CLI tools configuration for mohakim
{ config, pkgs, lib, ... }:

{
  imports = [
    # Import specific CLI tool configurations
    ./yazi.nix

    # Import home-manager modules for CLI tools
    ../../../../modules/home/cli/fish.nix
    ../../../../modules/home/cli/helix.nix
    ../../../../modules/home/cli/starship.nix
    ../../../../modules/home/cli/zellij.nix
  ];

  # Enable the CLI tools you want
  custom = {
    cli = {
      zellij.enable = true;
      fish.enable = true;
      helix.enable = true;
      starship.enable = true;
    };
  };

  # Additional shell aliases not handled by the fish module
  home.shellAliases = {
    # Git shortcuts
    gs = "git status";
    ga = "git add";
    gc = "git commit";
    gp = "git push";
    gl = "git log --oneline --graph";

    # Directory navigation
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";

    # Use exa instead of ls if available
    ls = "eza --icons --git";
    ll = "eza -la --icons --git";
    tree = "eza --tree --icons";

    # Use bat instead of cat
    cat = "bat";

    # Use fd instead of find
    find = "fd";

    # Add host-specific aliases
    rebuild = "cd ~/.config/nixos && sudo nixos-rebuild switch --flake .#nixos";
    hm = "cd ~/.config/nixos && home-manager switch --flake .#mohakim@nixos";
    edit = "cd ~/.config/nixos && hx";

    # Quick access to common directories
    dl = "cd ~/Downloads";
    docs = "cd ~/Documents";
    dev = "cd ~/Development";
    cfg = "cd ~/.config";

    # System operations
    update = "cd ~/.config/nixos && nix flake update && rebuild";
  };

  # Configure less
  programs.less = {
    enable = true;
    keys = ''
      #env
      LESS = -R
    '';
  };

  # Configure bat
  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
      italic-text = "always";
      style = "numbers,changes,header";
    };
  };

  # Configure fzf
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    defaultCommand = "fd --type file --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--info=inline"
      "--border"
      "--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8"
      "--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc"
      "--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
    ];
  };
}
