{ pkgs, ... }:

{
  programs.zellij.enable = true;

  xdg.configFile."zellij/config.kdl".text = ''
    theme "catppuccin-macchiato"
    pane_frames true
    mouse_mode true
    copy_on_select true
    scroll_buffer_size 10000
    default_mode "normal"
    session_serialization true
    // Use regular fish shell
    default_shell "${pkgs.fish}/bin/fish"
  '';
}
