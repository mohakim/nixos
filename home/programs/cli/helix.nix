{ pkgs, ... }:

{
  programs.helix = {
    enable = true;

    settings = {
      theme = "catppuccin_mocha";

      editor = {
        line-number = "relative";
        mouse = false;
        bufferline = "multiple";
        cursorline = true;
        color-modes = true;
        idle-timeout = 0;
        completion-trigger-len = 1;
        true-color = true;
        auto-format = true;
        auto-save = true;
        auto-completion = true;
        gutters = [ "diff" "diagnostics" "line-numbers" "spacer" ];
        auto-info = true;

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "block";
        };

        smart-tab.enable = true;

        file-picker = {
          hidden = false;
          git-ignore = true;
          git-global = true;
        };

        whitespace.render.tab = "all";

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
            h = "hover";
            d = "goto_definition";
            r = "rename_symbol";
            a = "code_action";
            s = "symbol_picker";
          };
        };

        select = {
          ";" = [ "collapse_selection" "keep_primary_selection" "normal_mode" ];
        };
      };
    };

    languages = {
      language = [
        {
          name = "rust";
          auto-format = true;
          language-servers = [ "rust-analyzer" ];
        }
        {
          name = "nix";
          auto-format = true;
          formatter.command = "nixpkgs-fmt";
        }
      ];

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
      };
    };
  };

  home.packages = with pkgs; [
    tailwindcss-language-server
    nil
    nixpkgs-fmt
  ];
}
