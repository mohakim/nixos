# Zellij terminal multiplexer configuration
{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.custom.cli.zellij;

  # Function to create a properly formatted config.kdl with Super key bindings
  mkZellijConfig =
    { theme }: ''
      // Zellij configuration with Super key bindings (no prefix needed)
      theme "${theme}"
    
      // Default configuration
      pane_frames true
      default_layout "compact"
      mouse_mode true
      copy_on_select false
      scroll_buffer_size 10000
    
      // Start in normal mode - no locking needed
      default_mode "normal"
    
      // Direct Super key bindings using "Super" syntax - no prefix needed
      keybinds {
        // Normal mode - always active
        normal {
          // Pane navigation with Super+jkli
          bind "Super j" { MoveFocus "Left"; }
          bind "Super k" { MoveFocus "Down"; }
          bind "Super i" { MoveFocus "Up"; }
          bind "Super l" { MoveFocus "Right"; }
        
          // Tab navigation
          bind "Super h" { GoToPreviousTab; }
          bind "Super ;" { GoToNextTab; }
        
          // Tab management
          bind "Super n" { NewTab; }
          bind "Super w" { CloseTab; }
        
          // Pane operations
          bind "Super -" { NewPane "Down"; }
          bind "Super =" { NewPane "Right"; }
          bind "Super x" { CloseFocus; }
        
          // Scrolling
          bind "Super (" { ScrollUp; }
          bind "Super )" { ScrollDown; }
        
          // Copy mode and utilities
          bind "Super c" { Copy; }
          bind "Super d" { Detach; }
        
          // Tab navigation by number
          bind "Super 1" { GoToTab 1; }
          bind "Super 2" { GoToTab 2; }
          bind "Super 3" { GoToTab 3; }
          bind "Super 4" { GoToTab 4; }
          bind "Super 5" { GoToTab 5; }
          bind "Super 6" { GoToTab 6; }
          bind "Super 7" { GoToTab 7; }
          bind "Super 8" { GoToTab 8; }
          bind "Super 9" { GoToTab 9; }
        
          // Switch to specific modes
          bind "Super p" { SwitchToMode "pane"; }
          bind "Super r" { SwitchToMode "resize"; }
          
          // Quick fullscreen toggle
          bind "Super f" { ToggleFocusFullscreen; }
          
          // Search mode
          bind "Super s" { SwitchToMode "search"; }
        }
      
        // Resize mode
        resize {
          bind "Esc" { SwitchToMode "normal"; }
          bind "Enter" { SwitchToMode "normal"; }
          
          // Resize with hjkl
          bind "h" { Resize "Increase Left"; }
          bind "j" { Resize "Increase Down"; }
          bind "k" { Resize "Increase Up"; }
          bind "l" { Resize "Increase Right"; }
          
          // Resize with HJKL (decrease)
          bind "H" { Resize "Decrease Left"; }
          bind "J" { Resize "Decrease Down"; }
          bind "K" { Resize "Decrease Up"; }
          bind "L" { Resize "Decrease Right"; }
          
          // Quick resize
          bind "=" { Resize "Increase"; }
          bind "-" { Resize "Decrease"; }
          
          // Super key shortcuts still work in resize mode
          bind "Super r" { SwitchToMode "normal"; }
          bind "Super p" { SwitchToMode "pane"; }
        }
      
        // Pane mode
        pane {
          bind "Esc" { SwitchToMode "normal"; }
          bind "Enter" { SwitchToMode "normal"; }
          
          // Navigation
          bind "h" { MoveFocus "Left"; }
          bind "j" { MoveFocus "Down"; }
          bind "k" { MoveFocus "Up"; }
          bind "l" { MoveFocus "Right"; }
          
          // Pane operations
          bind "n" { NewPane; }
          bind "d" { NewPane "Down"; }
          bind "r" { NewPane "Right"; }
          bind "x" { CloseFocus; }
          bind "f" { ToggleFocusFullscreen; }
          bind "z" { TogglePaneFrames; }
          bind "w" { ToggleFloatingPanes; }
          bind "e" { TogglePaneEmbedOrFloating; }
          
          // Switch modes
          bind "c" { SwitchToMode "resize"; }
          
          // Super key shortcuts still work in pane mode
          bind "Super p" { SwitchToMode "normal"; }
          bind "Super r" { SwitchToMode "resize"; }
        }
        
        // Search mode
        search {
          bind "Esc" { SwitchToMode "normal"; }
          bind "Enter" { SwitchToMode "normal"; }
          
          // Super key shortcuts work in search mode
          bind "Super s" { SwitchToMode "normal"; }
          bind "Super p" { SwitchToMode "pane"; }
          bind "Super r" { SwitchToMode "resize"; }
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
  };

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
    };

    # Create the config.kdl file with Super key bindings
    xdg.configFile."zellij/config.kdl".text = mkZellijConfig {
      theme = cfg.theme;
    };
  };
}
