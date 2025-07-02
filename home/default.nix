{ pkgs, ... }:

{
  imports = [
    # CLI programs
    ./programs/cli/alacritty.nix
    ./programs/cli/fish.nix
    ./programs/cli/helix.nix
    ./programs/cli/starship.nix
    ./programs/cli/yazi.nix
    ./programs/cli/zellij.nix

    # Desktop programs
    ./programs/desktop/niri.nix
    ./programs/desktop/proton-ge.nix
    ./programs/desktop/whatsapp.nix
    ./programs/desktop/fuzzel.nix
    ./programs/desktop/librewolf.nix

    # Services
    ./services/wl-gammarelay.nix
    ./services/mako.nix
    ./services/reminders.nix
    ./services/xwayland-satellite.nix

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
      xwayland-satellite
      xdg-desktop-portal-gnome

      # CLI essentials
      ripgrep
      fd
      bat
      eza
      fzf
      ouch
      rustup
      jq

      # Desktop applications
      wasistlos
      wootility
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
      teams-for-linux

      # Font
      nerd-fonts.jetbrains-mono

      # Icons
      papirus-icon-theme
    ];

    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      name = "Catppuccin-Mocha-Lavender-Cursors";
      size = 24; # Adjust size as needed (16, 24, 32, 48)
      package = pkgs.catppuccin-cursors.mochaLavender;
    };

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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Enhanced CLI tools
  programs = {
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
      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "audio/mp3" = "mpv.desktop";
      "audio/flac" = "mpv.desktop";
      "audio/wav" = "mpv.desktop";
    };
  };
}
