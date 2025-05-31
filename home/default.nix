{ pkgs, ... }:

{
  imports = [
    # CLI programs
    ./programs/cli/alacritty.nix
    ./programs/cli/fish.nix
    ./programs/cli/helix.nix
    ./programs/cli/reminders.nix
    ./programs/cli/starship.nix
    ./programs/cli/yazi.nix
    ./programs/cli/zellij.nix

    # Desktop programs
    ./programs/desktop/mako.nix
    ./programs/desktop/niri.nix
    ./programs/desktop/proton-ge.nix
    ./programs/desktop/wl-gammarelay.nix
  ];

  home = {
    username = "mohakim";
    homeDirectory = "/home/mohakim";
    stateVersion = "23.11";

    sessionVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
      TERMINAL = "alacritty";
      BROWSER = "librewolf";
    };

    packages = with pkgs; [
      # CLI essentials
      ripgrep
      fd
      bat
      eza
      fzf
      bottom
      ouch
      rustup
      pandoc
      jq

      # Desktop applications
      fuzzel
      krita
      obsidian
      element-desktop
      librewolf
      webcord
      swww
      grim
      slurp
      wl-clipboard
      mpv

      # Fonts
      nerd-fonts.jetbrains-mono
    ];

    shellAliases = {
      # Directory navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # Modern CLI tools
      ls = "eza --icons --git";
      ll = "eza -la --icons --git";
      tree = "eza --tree --icons";
      cat = "bat";
      find = "fd";

      # Git shortcuts
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline --graph";

      # System operations
      rebuild = "cd ~/.config/nixos && sudo nixos-rebuild switch --flake .#nixos";
      hm = "cd ~/.config/nixos && home-manager switch --flake .#mohakim@nixos";
      edit = "cd ~/.config/nixos && hx";
      update = "cd ~/.config/nixos && nix flake update && rebuild";

      # Quick navigation
      dl = "cd ~/Downloads";
      docs = "cd ~/Documents";
      dev = "cd ~/Development";
      cfg = "cd ~/.config";
    };
  };

  programs.home-manager.enable = true;

  # Font configuration
  fonts.fontconfig.enable = true;

  # Git configuration
  programs.git = {
    enable = true;
    userName = "mohakim";
    userEmail = "m.abdihakim@proton.me";
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

  # Enhanced CLI tools
  programs = {
    less = {
      enable = true;
      keys = "LESS = -R";
    };

    bat = {
      enable = true;
      config = {
        theme = "Dracula";
        italic-text = "always";
        style = "numbers,changes,header";
      };
    };

    fzf = {
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
  };

  # XDG MIME associations
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
      "application/pdf" = "librewolf.desktop";
      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "audio/mp3" = "mpv.desktop";
      "audio/flac" = "mpv.desktop";
      "audio/wav" = "mpv.desktop";
    };
  };

  # Fuzzel application launcher
  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    [main]
    font=JetBrainsMono Nerd Font:size=14
    terminal=alacritty
    dpi-aware=auto
    prompt="❯   "
    icon-theme=Papirus-Dark
    
    [colors]
    background=1e1e2eff
    text=cdd6f4ff
    match=f38ba8ff
    selection=89b4faff
    selection-text=1e1e2eff
    border=89b4faff
    
    [border]
    width=3
    radius=8
  '';
}
