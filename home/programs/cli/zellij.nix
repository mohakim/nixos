{ ... }:

{
  programs.zellij.enable = true;

  xdg.configFile."zellij/config.kdl".text = ''
    // Optimized Zellij configuration with conflict-free Super key bindings
    theme "catppuccin-macchiato"

    pane_frames true
    default_layout "compact"
    mouse_mode true
    copy_on_select false
    scroll_buffer_size 10000
    default_mode "normal"

    keybinds {
      normal {
        // === PANE NAVIGATION (Conflict-free vim-like) ===
        bind "Super j" { MoveFocus "Left"; }      // J for left
        bind "Super k" { MoveFocus "Down"; }      // K for down
        bind "Super i" { MoveFocus "Up"; }        // I for up  
        bind "Super l" { MoveFocus "Right"; }     // L for right
      
        // === TAB NAVIGATION (Safe adjacent keys) ===
        bind "Super q" { GoToPreviousTab; }       // Q for previous
        bind "Super w" { GoToNextTab; }           // W for next
      
        // === CREATION (Safe keys) ===
        bind "Super t" { NewTab; }                // T for Tab
        bind "Super s" { NewPane "Down"; }        // S for Split down
        bind "Super v" { NewPane "Right"; }       // V for Vertical split
      
        // === DESTRUCTION ===
        bind "Super x" { CloseFocus; }            // X for close pane
        bind "Super z" { CloseTab; }              // Z for close tab
      
        // === TAB JUMPING (Safe top row keys) ===
        bind "Super u" { GoToTab 1; }             // Safe keys, no conflicts
        bind "Super o" { GoToTab 2; }             // 
        bind "Super p" { GoToTab 3; }             //
        bind "Super y" { GoToTab 4; }             // 
        bind "Super e" { GoToTab 5; }             // Extra if needed
      
        // === MODES (Conflict-free alternatives) ===
        bind "Super n" { SwitchToMode "resize"; } // N for resizing Numbers
        bind "Super a" { SwitchToMode "pane"; }   // A for pane Arrangement
        bind "Super g" { ToggleFocusFullscreen; } // G for Go big/fullscreen
      
        // === UTILITIES (Safe keys) ===
        bind "Super d" { Detach; }                // D for Detach  
        bind "Super b" { ScrollUp; }              // B for scroll Back/up
        bind "Super ." { ScrollDown; }            // Period for scroll down
        bind "Super ;" { Copy; }                  // Semicolon for copy
        bind "Super /" { SwitchToMode "search"; } // / for search (universal)
      }
    
      resize {
        bind "Esc" { SwitchToMode "normal"; }
        bind "Enter" { SwitchToMode "normal"; }
        
        // Use same navigation keys for consistency
        bind "j" { Resize "Increase Left"; }      // Consistent with main nav
        bind "k" { Resize "Increase Down"; }
        bind "i" { Resize "Increase Up"; }
        bind "l" { Resize "Increase Right"; }
        
        // Shifted versions for decrease
        bind "J" { Resize "Decrease Left"; }
        bind "K" { Resize "Decrease Down"; }
        bind "I" { Resize "Decrease Up"; }
        bind "L" { Resize "Decrease Right"; }
        
        // Overall size adjustments
        bind "=" { Resize "Increase"; }
        bind "-" { Resize "Decrease"; }
        
        // Quick mode switches
        bind "Super n" { SwitchToMode "normal"; }
        bind "Super a" { SwitchToMode "pane"; }
      }
    
      pane {
        bind "Esc" { SwitchToMode "normal"; }
        bind "Enter" { SwitchToMode "normal"; }
        
        // Navigation (consistent with main nav)
        bind "j" { MoveFocus "Left"; }
        bind "k" { MoveFocus "Down"; }
        bind "i" { MoveFocus "Up"; }
        bind "l" { MoveFocus "Right"; }
        
        // Pane operations
        bind "t" { NewPane; }                     // T for new pane
        bind "s" { NewPane "Down"; }              // S for split down
        bind "v" { NewPane "Right"; }             // V for vertical split
        bind "x" { CloseFocus; }                  // X for close
        bind "g" { ToggleFocusFullscreen; }       // G for fullscreen
        bind "f" { TogglePaneFrames; }            // F for frames (safe in pane mode)
        bind "w" { ToggleFloatingPanes; }         // W for floating
        bind "e" { TogglePaneEmbedOrFloating; }   // E for embed
        bind "r" { SwitchToMode "resize"; }       // R for resize (safe in pane mode)
        
        // Quick mode switches  
        bind "Super a" { SwitchToMode "normal"; }
        bind "Super n" { SwitchToMode "resize"; }
      }
      
      search {
        bind "Esc" { SwitchToMode "normal"; }
        bind "Enter" { SwitchToMode "normal"; }
        
        // Quick mode switches
        bind "Super /" { SwitchToMode "normal"; }
        bind "Super a" { SwitchToMode "pane"; }
        bind "Super n" { SwitchToMode "resize"; }
      }
    }
  '';
}
