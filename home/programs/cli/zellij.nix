{ pkgs, ... }:

let
  # Simple shell wrapper that checks for .envrc in current directory
  direnvShell = pkgs.writeShellScript "direnv-shell" ''
    if [[ -f .envrc ]]; then
      ${pkgs.direnv}/bin/direnv exec . ${pkgs.fish}/bin/fish
    else
      exec ${pkgs.fish}/bin/fish
    fi
  '';
in
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
    // Use direnv-aware shell by default
    default_shell "${direnvShell}"
    
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
}
