{ ... }:

{
  programs.zellij.enable = true;

  xdg.configFile."zellij/config.kdl".text = ''
    // Zellij configuration with Super key bindings
    theme "catppuccin-macchiato"

    pane_frames true
    default_layout "compact"
    mouse_mode true
    copy_on_select false
    scroll_buffer_size 10000
    default_mode "normal"

    keybinds {
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
        bind "Super f" { ToggleFocusFullscreen; }
        bind "Super s" { SwitchToMode "search"; }
      }
    
      resize {
        bind "Esc" { SwitchToMode "normal"; }
        bind "Enter" { SwitchToMode "normal"; }
        
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
        
        bind "Super r" { SwitchToMode "normal"; }
        bind "Super p" { SwitchToMode "pane"; }
      }
    
      pane {
        bind "Esc" { SwitchToMode "normal"; }
        bind "Enter" { SwitchToMode "normal"; }
        
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
        
        bind "Super p" { SwitchToMode "normal"; }
        bind "Super r" { SwitchToMode "resize"; }
      }
      
      search {
        bind "Esc" { SwitchToMode "normal"; }
        bind "Enter" { SwitchToMode "normal"; }
        
        bind "Super s" { SwitchToMode "normal"; }
        bind "Super p" { SwitchToMode "pane"; }
        bind "Super r" { SwitchToMode "resize"; }
      }
    }
  '';
}
