{ ... }:
{
  programs.zellij.enable = true;

  xdg.configFile."zellij/config.kdl".text = ''
    theme "catppuccin-macchiato"
    pane_frames true
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
        bind "Super u" { GoToPreviousTab; }
        bind "Super o" { GoToNextTab; }
      }
    }
  '';
}
