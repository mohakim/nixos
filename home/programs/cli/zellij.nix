{ ... }:
{
  programs.zellij.enable = true;

  xdg.configFile."zellij/config.kdl".text = ''
    // Zellij configuration with Super key bindings + sidebar layout
    theme "catppuccin-macchiato"
    pane_frames true
    default_layout "sidebar"
    mouse_mode true
    copy_on_select false
    scroll_buffer_size 10000
    default_mode "normal"
    
    keybinds {
      normal {
        // Pane navigation with Super+jkli (your existing scheme)
        bind "Super j" { MoveFocus "Left"; }
        bind "Super k" { MoveFocus "Down"; }
        bind "Super i" { MoveFocus "Up"; }
        bind "Super l" { MoveFocus "Right"; }
      
        // Tab navigation (your existing scheme)
        bind "Super h" { GoToPreviousTab; }
        bind "Super ;" { GoToNextTab; }
      
        // Tab management (your existing scheme)
        bind "Super n" { NewTab; }
        bind "Super w" { CloseTab; }
      
        // Pane operations (your existing scheme)
        bind "Super -" { NewPane "Down"; }
        bind "Super =" { NewPane "Right"; }
        bind "Super x" { CloseFocus; }
      
        // Scrolling (your existing scheme)
        bind "Super (" { ScrollUp; }
        bind "Super )" { ScrollDown; }
      
        // Copy mode and utilities (your existing scheme)
        bind "Super c" { Copy; }
        bind "Super d" { Detach; }
      
        // Tab navigation by number (your existing scheme)
        bind "Super 1" { GoToTab 1; }
        bind "Super 2" { GoToTab 2; }
        bind "Super 3" { GoToTab 3; }
        bind "Super 4" { GoToTab 4; }
        bind "Super 5" { GoToTab 5; }
        bind "Super 6" { GoToTab 6; }
        bind "Super 7" { GoToTab 7; }
        bind "Super 8" { GoToTab 8; }
        bind "Super 9" { GoToTab 9; }
      
        // Switch to specific modes (your existing scheme)
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

  # Create the sidebar layout file
  xdg.configFile."zellij/layouts/sidebar.kdl".text = ''
    layout {
        default_tab_template {
            pane size=1 borderless=true {
                plugin location="zellij:tab-bar"
            }
            children
            pane size=2 borderless=true {
                plugin location="zellij:status-bar"
            }
        }
        
        tab name="Edit" focus=true {
            pane split_direction="vertical" {
                pane size="25%" {
                    name "yazi-sidebar"
                    command "yazi"
                }
                pane size="75%" {
                    name "helix-main"
                    command "hx"
                    args "."
                }
            }
        }
        
        tab name="Command" {
            pane split_direction="horizontal" {
                pane size="50%" {
                    name "compile-pane"
                    command "fish"
                }
                pane size="50%" {
                    name "run-pane" 
                    command "fish"
                }
            }
        }
    }
  '';

  # # Simple fish integration - just auto-attach
  # programs.fish.interactiveShellInit = ''
  #   if status is-interactive
  #       and test "$TERM_PROGRAM" = "Alacritty"
  #       and not set -q ZELLIJ
  #       and not set -q VSCODE_PID
  #       zellij attach -c default
  #   end
  # '';
}
