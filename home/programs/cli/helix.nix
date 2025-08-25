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

      # Goto Mode Remapping
      keys.normal.g = {
        "n" = "goto_line_start";
        "i" = "goto_line_end";
      };
    };

    languages = {
      language = [
        {
          name = "rust";
          auto-format = true;
          language-servers = [ "rust-analyzer" "tailwindcss-ls" ];
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
        tailwindcss-ls = {
          config.tailwindCSS = {
            includeLanguages = { rust = "html"; };
            emmetCompletions = true;
            validate = true;
            classAttributes = [ "class" "className" "class:list" ];
            experimental.classRegex = [
              "class\\s*:\\s*\"([^\"]*)\"" # RSX: class: "..."
              [ "class\\s*:\\s*\\{([\\s\\S]*?)\\}" "[\"'`]([^\"'`]*)[\"'`]" ] # RSX: class: { ... }
            ];
          };
          command = "tailwindcss-language-server";
          args = [ "--stdio" ];
        };
      };
    };
  };

  home.packages = with pkgs; [
    tailwindcss-language-server
    vscode-langservers-extracted
    nil
    nixpkgs-fmt
  ];
}
