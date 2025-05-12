# Zellij terminal multiplexer configuration
{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.custom.cli.zellij;

  # Function to create a properly formatted config.kdl
  mkZellijConfig =
    { theme
    , prefixKey
    }: ''
      // Zellij configuration with prefix key style
      theme "${theme}"
    
      // Default configuration
      pane_frames true
      default_layout "compact"
      mouse_mode true
      copy_on_select false
      scroll_buffer_size 10000
    
      // Start in locked mode, use prefix key to enter normal mode
      default_mode "locked"
    
      // Keybindings using prefix key style (like tmux/screen)
      keybinds {
        // Locked mode - only respond to the prefix key
        locked {
          bind "${prefixKey}" { SwitchToMode "normal"; }
        }
      
        // Normal mode - accessible after pressing the prefix key
        normal {
          // Return to locked mode with Escape or prefix again
          // Use Esc key for returning to locked mode
          bind "Esc" { SwitchToMode "locked"; }
        
          // Navigation with jkli - matches your muscle memory
          bind "j" { MoveFocus "Left"; }
          bind "k" { MoveFocus "Down"; }
          bind "i" { MoveFocus "Up"; }
          bind "l" { MoveFocus "Right"; }
        
          // Tab navigation
          bind "h" { GoToPreviousTab; }
          bind ";" { GoToNextTab; }
        
          // Tab management
          bind "n" { NewTab; }
          bind "w" { CloseTab; }
        
          // Pane operations
          bind "-" { NewPane "Down"; }
          bind "=" { NewPane "Right"; }
          bind "x" { CloseFocus; }
        
          // Scrolling
          bind "[" { ScrollUp; }
          bind "]" { ScrollDown; }
        
          // Copy mode and utilities
          bind "c" { Copy; }
          bind "d" { Detach; }
        
          // Layout navigation
          bind "1" { GoToTab 1; }
          bind "2" { GoToTab 2; }
          bind "3" { GoToTab 3; }
          bind "4" { GoToTab 4; }
          bind "5" { GoToTab 5; }
        
          // Switch to specific modes
          bind "p" { SwitchToMode "pane"; }
          bind "r" { SwitchToMode "resize"; }
        }
      
        // Resize mode
        resize {
          bind "Esc" { SwitchToMode "locked"; }
          bind "${prefixKey}" { SwitchToMode "locked"; }
          bind "h" { Resize "Increase Left"; }
          bind "j" { Resize "Increase Down"; }
          bind "k" { Resize "Increase Up"; }
          bind "l" { Resize "Increase Right"; }
          bind "H" { Resize "Decrease Left"; }
          bind "J" { Resize "Decrease Down"; }
          bind "K" { Resize "Decrease Up"; }
          bind "L" { Resize "Decrease Right"; }
          bind "=" { Resize "Increase"; }
          bind "-" { Resize "Decrease"; }
        }
      
        // Pane mode
        pane {
          bind "Esc" { SwitchToMode "locked"; }
          bind "${prefixKey}" { SwitchToMode "locked"; }
          bind "h" { MoveFocus "Left"; }
          bind "j" { MoveFocus "Down"; }
          bind "k" { MoveFocus "Up"; }
          bind "l" { MoveFocus "Right"; }
          bind "n" { NewPane; }
          bind "d" { NewPane "Down"; }
          bind "r" { NewPane "Right"; }
          bind "x" { CloseFocus; }
          bind "f" { ToggleFocusFullscreen; }
          bind "z" { TogglePaneFrames; }
          bind "w" { ToggleFloatingPanes; }
          bind "e" { TogglePaneEmbedOrFloating; }
          bind "c" { SwitchToMode "resize"; }
        }
      }
    '';
in
{
  options.custom.cli.zellij = {
    enable = mkEnableOption "Enable Zellij terminal multiplexer";

    theme = mkOption {
      type = types.enum [
        # Dark Themes
        "ansi"
        "ao"
        "atelier-sulphurpool"
        "ayu_mirage"
        "ayu_dark"
        "catppuccin-frappe"
        "catppuccin-macchiato"
        "cyber-noir"
        "blade-runner"
        "retro-wave"
        "dracula"
        "everforest-dark"
        "gruvbox-dark"
        "iceberg-dark"
        "kanagawa"
        "lucario"
        "menace"
        "molokai-dark"
        "night-owl"
        "nightfox"
        "nord"
        "one-half-dark"
        "onedark"
        "solarized-dark"
        "tokyo-night-dark"
        "tokyo-night-storm"
        "tokyo-night"
        "vesper"
        # Light Themes
        "ayu_light"
        "catppuccin-latte"
        "everforest-light"
        "gruvbox-light"
        "iceberg-light"
        "dayfox"
        "pencil-light"
        "solarized-light"
        "tokyo-night-light"
      ];
      default = "catppuccin-macchiato";
      description = "Zellij theme";
    };

    prefixKey = mkOption {
      type = types.str;
      default = "Ctrl g";
      description = "Prefix key to enter Zellij command mode";
    };
  };

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
    };

    # Create the config.kdl file with precise KDL syntax
    xdg.configFile."zellij/config.kdl".text = mkZellijConfig {
      theme = cfg.theme;
      prefixKey = cfg.prefixKey;
    };
  };
}

