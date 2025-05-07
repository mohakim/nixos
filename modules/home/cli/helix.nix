# Helix editor configuration module
{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.custom.cli.helix;
in
{
  options.custom.cli.helix = {
    enable = mkEnableOption "Enable Helix editor configuration";

    theme = mkOption {
      type = types.str;
      default = "catppuccin_mocha";
      description = "The theme to use for Helix";
    };

    lineNumbers = mkOption {
      type = types.enum [ "absolute" "relative" ];
      default = "relative";
      description = "Line number display style";
    };

    enableAutoFormat = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable auto-formatting";
    };

    enableAutoSave = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable auto-saving";
    };

    extraLanguages = mkOption {
      type = types.listOf types.attrs;
      default = [ ];
      description = "Additional language configurations";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Additional packages to install for Helix";
    };
  };

  config = mkIf cfg.enable {
    # Enable Helix
    programs.helix = {
      enable = true;

      # Main editor configuration
      settings = {
        theme = cfg.theme;

        editor = {
          line-number = cfg.lineNumbers;
          mouse = false;
          bufferline = "multiple";
          cursorline = true;
          color-modes = true;
          idle-timeout = 0;
          completion-trigger-len = 1;
          true-color = true;
          auto-format = cfg.enableAutoFormat;
          auto-save = cfg.enableAutoSave;
          auto-completion = true;
          gutters = [ "diff" "diagnostics" "line-numbers" "spacer" ];
          auto-info = true;

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "block";
          };

          smart-tab = {
            enable = true;
          };

          file-picker = {
            hidden = false;
            git-ignore = true;
            git-global = true;
          };

          whitespace.render = {
            tab = "all";
          };

          lsp = {
            enable = true;
            snippets = true;
            goto-reference-include-declaration = true;
            display-messages = true;
            display-inlay-hints = true;
          };

          indent-guides = {
            render = true;
            character = "╎";
            skip-levels = 1;
          };

          soft-wrap = {
            enable = true;
            max-wrap = 20;
            max-indent-retain = 40;
            wrap-indicator = "";
          };

          statusline = {
            left = [
              "mode"
              "spinner"
              "version-control"
              "read-only-indicator"
              "file-name"
              "file-modification-indicator"
            ];
            center = [ "diagnostics" ];
            right = [
              "register"
              "position"
              "position-percentage"
              "file-type"
            ];
            separator = "│";
          };
        };

        # Key bindings
        keys = {
          normal = {
            esc = [ "collapse_selection" "keep_primary_selection" ];
            ret = [ "move_line_down" "goto_first_nonwhitespace" ];
            "}" = "goto_next_paragraph";
            "{" = "goto_prev_paragraph";
            G = "goto_file_end";
            g = { g = "goto_file_start"; e = "goto_last_line"; };
            "[" = "shrink_selection";
            "]" = "expand_selection";
            "S-up" = "extend_to_line_bounds";
            "S-down" = "extend_line_below";
            "S-left" = "extend_char_left";
            "S-right" = "extend_char_right";
            "/" = "search";
            n = "search_next";
            N = "search_prev";
            "C-up" = [ "extend_to_line_bounds" "select_prev_sibling" ];
            "C-down" = [ "extend_to_line_bounds" "select_next_sibling" ];
            C = "copy_selection_on_next_line";
            K = "hover";

            space = {
              f = "file_picker";
              b = "buffer_picker";
              "/" = "toggle_comments";
              h = "hover";
              d = "goto_definition";
              r = "rename_symbol";
              a = "code_action";
              s = "symbol_picker";
            };
          };

          select = {
            ";" = [ "collapse_selection" "keep_primary_selection" "normal_mode" ];

            space = {
              "/" = "toggle_comments";
            };
          };
        };
      };

      # Language configuration
      languages = {
        language = [
          # Rust configuration
          {
            name = "rust";
            auto-format = cfg.enableAutoFormat;
            language-servers = [ "rust-analyzer" ];
          }

          # TypeScript configuration
          {
            name = "typescript";
            auto-format = cfg.enableAutoFormat;
            language-servers = [
              "typescript-language-server"
              "tailwindcss-react"
            ];
            formatter = {
              command = "npx";
              args = [ "prettier" "--parser" "typescript" ];
            };
          }

          # TSX configuration
          {
            name = "tsx";
            auto-format = cfg.enableAutoFormat;
            language-servers = [
              "typescript-language-server"
              "tailwindcss-react"
            ];
            formatter = {
              command = "npx";
              args = [ "prettier" "--parser" "typescript" ];
            };
          }

          # CSS configuration
          {
            name = "css";
            auto-format = cfg.enableAutoFormat;
            language-servers = [
              "vscode-css"
              "tailwindcss-react"
            ];
          }

          # JSX configuration
          {
            name = "jsx";
            auto-format = cfg.enableAutoFormat;
            grammar = "javascript";
            language-servers = [
              "typescript-language-server"
              "tailwindcss-react"
            ];
            formatter = {
              command = "npx";
              args = [ "prettier" "--parser" "typescript" ];
            };
          }

          # JavaScript configuration
          {
            name = "javascript";
            auto-format = cfg.enableAutoFormat;
            language-servers = [
              "typescript-language-server"
              "tailwindcss-react"
            ];
            formatter = {
              command = "npx";
              args = [ "prettier" "--parser" "typescript" ];
            };
          }

          # Nix configuration
          {
            name = "nix";
            auto-format = cfg.enableAutoFormat;
            formatter = {
              command = "nixpkgs-fmt";
            };
          }
        ] ++ cfg.extraLanguages;

        language-server = {
          rust-analyzer = {
            config = {
              inlayHints = {
                bindingModeHints.enable = false;
                closingBraceHints.minlines = 10;
                closureReturnTypeHints.enable = "with_block";
                discriminantHints.enable = "fieldless";
                lifetimeElisionHints.enable = "skip_trivial";
                typeHints.hideClosureInitialization = false;
              };
            };
          };

          "vscode-css" = {
            command = "vscode-css-languageserver";
            args = [ "--stdio" ];
            config = { };
          };

          "tailwindcss-react" = {
            command = "tailwindcss-language-server";
            args = [ "--stdio" ];
            config = { };
          };
        };
      };
    };

    # Install required dependencies
    home.packages = with pkgs; [
      # Language servers
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      tailwindcss-language-server

      # Formatters
      nixpkgs-fmt
      nodePackages.prettier
    ] ++ cfg.extraPackages;
  };
}
