{ config, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Initialize Starship prompt
      ${if config.programs.starship.enable then "starship init fish | source" else ""}
      
      # Remove fish greeting
      set -U fish_greeting ""
      
      # Set environment variables
      set -gx EDITOR hx
      set -gx VISUAL hx
      
      # Initialize helix key bindings
      set -g fish_key_bindings fish_vi_key_bindings
    '';

    functions = {
      # Your existing audio toggle function
      toggle-audio = {
        body = ''
          set speakers_name "alsa_output.pci-0000_06_00.6.analog-stereo"
          set earphones_name "alsa_output.usb-3142_fifine_Microphone-00.analog-stereo"
          set speakers_id (pw-cli info $speakers_name | head -n 1 | awk '{print $2}')
          set earphones_id (pw-cli info $earphones_name | head -n 1 | awk '{print $2}')
          switch "$argv[1]"
            case "speakers"
              wpctl set-default "$speakers_id"
            case "headset"
              wpctl set-default "$earphones_id"
            case "*"
              echo "Unknown audio device. Use: speakers, earphones"
          end
        '';
        description = "Switch between Family speakers, Gaming Headset, and Bluetooth Earbuds";
      };
    };
  };
}

