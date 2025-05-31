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
    '';

    functions = {
      # Audio device switching
      toggle-audio = {
        body = ''
          set family_name "alsa_output.pci-0000_05_00.6.analog-stereo"
          set headset_name "alsa_output.usb-Logitech_G733_Gaming_Headset-00.analog-stereo"
          set earbuds_name "bluez_output.3C_B0_ED_50_C0_1C.1"

          set family_id (pw-cli info $family_name | head -n 1 | awk '{print $2}')
          set headset_id (pw-cli info $headset_name | head -n 1 | awk '{print $2}')
          set earbuds_id (pw-cli info $earbuds_name | head -n 1 | awk '{print $2}')

          switch "$argv[1]"
            case "family"
              wpctl set-default "$family_id"
            case "headset"
              wpctl set-default "$headset_id"
            case "earbuds"
              wpctl set-default "$earbuds_id"
            case "*"
              echo "Unknown audio device. Use: family, headset, or earbuds"
          end
        '';
        description = "Switch between Family speakers, Gaming Headset, and Bluetooth Earbuds";
      };
    };
  };
}
