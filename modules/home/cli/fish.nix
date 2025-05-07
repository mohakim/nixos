# Fish shell configuration module
{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.custom.cli.fish;
in
{
  options.custom.cli.fish = {
    enable = mkEnableOption "Enable Fish shell configuration";

    startNiri = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to start niri on login";
    };

    greeting = mkOption {
      type = types.str;
      default = "";
      description = "The greeting message when starting a new shell";
    };

    extraInitCommands = mkOption {
      type = types.lines;
      default = "";
      description = "Extra commands to add to the interactive shell init";
    };

    extraAliases = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Additional shell aliases";
    };

    editor = mkOption {
      type = types.str;
      default = "helix";
      description = "Default editor";
    };
  };

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;

      # Interactive shell initialization
      interactiveShellInit = ''
        # Initialize Starship prompt if enabled
        ${optionalString config.programs.starship.enable "${pkgs.starship}/bin/starship init fish | source"}
        
        # Remove fish greeting
        set -U fish_greeting "${cfg.greeting}"
        
        # Set environment variables
        set -gx EDITOR ${cfg.editor}
        set -gx VISUAL ${cfg.editor}
        
        # Custom init commands
        ${cfg.extraInitCommands}
      '';

      # Login shell configuration
      # loginShellInit = mkIf cfg.startNiri ''
      #   # Start niri session if this is a login shell
      #   # Only run this on TTY (not inside an existing session)
      #   if status is-login; and test -z "$DISPLAY"; and test (tty) = "/dev/tty1"
      #     exec niri --session
      #   end
      # '';

      # Shell aliases - combine default with custom
      shellAliases = {
        # Basic aliases
        ".." = "cd ..";
      } // cfg.extraAliases;

      # Fish shell functions
      functions = {
        # Fish function to extract archives
        extract = {
          body = ''
            if test -f $argv[1]
              switch $argv[1]
                case "*.tar.bz2"
                  tar xjf $argv[1]
                case "*.tar.gz"
                  tar xzf $argv[1]
                case "*.bz2"
                  bunzip2 $argv[1]
                case "*.rar"
                  unrar x $argv[1]
                case "*.gz"
                  gunzip $argv[1]
                case "*.tar"
                  tar xf $argv[1]
                case "*.tbz2"
                  tar xjf $argv[1]
                case "*.tgz"
                  tar xzf $argv[1]
                case "*.zip"
                  unzip $argv[1]
                case "*.Z"
                  uncompress $argv[1]
                case "*.7z"
                  7z x $argv[1]
                case "*"
                  echo "'$argv[1]' cannot be extracted via extract"
              end
            else
              echo "'$argv[1]' is not a valid file"
            end
          '';
          description = "Extract various archive formats";
        };

        # Quick Nix rebuild
        rebuild = {
          body = ''
            cd ~/.config/nixos && sudo nixos-rebuild switch --flake .#nixos
          '';
          description = "Rebuild NixOS configuration";
        };

        # Quick home-manager rebuild
        hm = {
          body = ''
            cd ~/.config/nixos && home-manager switch --flake .#mohakim@nixos
          '';
          description = "Rebuild home-manager configuration";
        };
      };
    };

    # Install dependencies
    home.packages = with pkgs; [
      fish
    ];
  };
}
