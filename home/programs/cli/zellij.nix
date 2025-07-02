# Add this to your home/programs/cli/zellij.nix file

{ pkgs, ... }:

{
  programs.zellij.enable = true;

  xdg.configFile."zellij/config.kdl".text = ''
    theme "catppuccin-macchiato"
    pane_frames true
    mouse_mode true
    copy_on_select false
    scroll_buffer_size 10000
    default_mode "normal"
    session_serialization false   
    // Use regular fish shell
    default_shell "${pkgs.fish}/bin/fish"
    
    keybinds {
      normal {
        // Pane navigation with Super+jkli (your existing scheme)
        bind "Super j" { MoveFocus "Left"; }
        bind "Super k" { MoveFocus "Down"; }
        bind "Super i" { MoveFocus "Up"; }
        bind "Super l" { MoveFocus "Right"; }
      
        // Tab navigation (your existing scheme)
        bind "Super u" { GoToPreviousTab; }
        bind "Super o" { GoToNextTab; }

        // Avoid keyd conflicts
        unbind "Alt h"
        unbind "Alt j" 
        unbind "Alt k"
        unbind "Alt l"
        unbind "Alt Left"
        unbind "Alt Right" 
        unbind "Alt Up"
        unbind "Alt Down"
      }
    }
  '';

  # Add the practice layout
  xdg.configFile."zellij/layouts/practice.kdl".text = ''
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
        
        tab name="Sandbox" focus=true {
            pane split_direction="vertical" {
                // Left pane - Glow for reading lessons (40% width)
                pane size="40%" {
                    name "Lesson"
                    command "fish"
                    args "-c" "direnv exec . glow src/$RUST_CHAPTER"
                    cwd "~/projects/100-exercises-to-learn-rust/book"
                }
                
                // Right pane - Helix for exercises (60% width)
                pane size="60%" {
                    name "Exercise"
                    command "fish"
                    args "-c" "direnv exec . hx ."
                    cwd "~/projects/100-exercises-to-learn-rust/exercises/$RUST_CHAPTER"
                    focus true
                }
            }
        }
        
        tab name="Solutions" {
            pane {
                name "Solutions"
                command "hx"
                args "."
                cwd "~/100-exercises-to-learn-rust/exercises/$RUST_CHAPTER"
            }
        }
    }
  '';
}
