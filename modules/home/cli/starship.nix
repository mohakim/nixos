# Starship prompt configuration module
{ config, lib, ... }:

with lib;
let
  cfg = config.custom.cli.starship;
in
{
  options.custom.cli.starship = {
    enable = mkEnableOption "Enable Starship prompt configuration";

    promptFormat = mkOption {
      type = types.str;
      default = concatStrings [
        "[░▒▓](#a3aed2)"
        "[ 󱄅 ](bg:#a3aed2 fg:#090c0c)"
        "[](bg:#769ff0 fg:#a3aed2)"
        "$directory"
        "[](fg:#769ff0 bg:#394260)"
        "$git_branch"
        "$git_status"
        "[](fg:#394260 bg:#212736)"
        "$nodejs"
        "$rust"
        "$golang"
        "$php"
        "[](fg:#212736 bg:#1d2230)"
        "$time"
        "[](fg:#1d2230)"
        "\n$character"
      ];
      description = "The format of the Starship prompt";
    };

    showTime = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to show the time in the prompt";
    };

    directoryTruncationLength = mkOption {
      type = types.int;
      default = 3;
      description = "Length to truncate directory paths";
    };

    additionalModules = mkOption {
      type = types.attrsOf types.attrs;
      default = { };
      description = "Additional module configurations to add";
    };
  };

  config = mkIf cfg.enable {
    # Enable Starship
    programs.starship = {
      enable = true;

      # Use custom settings
      settings = {
        format = cfg.promptFormat;

        directory = {
          style = "fg:#e3e5e5 bg:#769ff0";
          format = "[ $path ]($style)";
          truncation_length = cfg.directoryTruncationLength;
          truncation_symbol = "…/";
          truncate_to_repo = false;
          substitutions = {
            "Documents" = " ";
            "Downloads" = " ";
            "Music" = " ";
            "Pictures" = " ";
          };
        };

        git_branch = {
          symbol = "";
          style = "bg:#394260";
          format = "[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)";
        };

        git_status = {
          style = "bg:#394260";
          format = "[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)]($style)";
        };

        nodejs = {
          symbol = "";
          style = "bg:#212736";
          format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
        };

        rust = {
          symbol = "";
          style = "bg:#212736";
          format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
        };

        golang = {
          symbol = "";
          style = "bg:#212736";
          format = "[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)";
        };

        time = {
          disabled = false;
          style = "bg:#1d2230";
          format = "[[ $time ](fg:#769ff0 bg:#1d2230)]($style)";
        };

        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
        };
      } // cfg.additionalModules;
    };
  };
}
