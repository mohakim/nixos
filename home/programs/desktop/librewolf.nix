# LibreWolf with Cascade + Catppuccin Mocha
{ lib, config, cascade, ... }:

let
  chromeDir =
    let p = config.programs.librewolf.profiles.default;
    in ".librewolf/${p.path}/chrome";

  coreIncludes = [
    "cascade-config.css"
    "cascade-layout.css"
    "cascade-responsive.css"
    "cascade-tabs.css"
  ];
in
{
  programs.librewolf = {
    enable = true;

    profiles.default = {
      id = 0;
      isDefault = true;

      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        "layers.acceleration.force-enabled" = true;
        "gfx.webrender.all" = true;
      };

      userChrome = builtins.readFile "${cascade}/chrome/userChrome.css";
    };
  };

  home.file =
    lib.listToAttrs
      (map
        (f: {
          name = "${chromeDir}/includes/${f}";
          value = { source = "${cascade}/chrome/includes/${f}"; };
        })
        coreIncludes)
    // {
      "${chromeDir}/includes/cascade-colours.css" = {
        source = "${cascade}/integrations/catppuccin/cascade-mocha.css";
      };
    };

  xdg.mimeApps.defaultApplications = {
    "text/html" = "librewolf.desktop";
    "x-scheme-handler/http" = "librewolf.desktop";
    "x-scheme-handler/https" = "librewolf.desktop";
    "x-scheme-handler/about" = "librewolf.desktop";
    "x-scheme-handler/unknown" = "librewolf.desktop";
    "application/pdf" = "librewolf.desktop";
  };
}
