{ ... }:

let
  # Path to your textfox assets
  textfoxPath = ../../../assets/textfox;
in
{
  programs.librewolf = {
    enable = true;

    # Enable userChrome.css and other required settings from textfox user.js
    settings = {
      # Required for textfox CSS to work
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "svg.context-properties.content.enabled" = true;
      "layout.css.has-selector.enabled" = true;

      # Additional privacy settings (you can customize these)
      "privacy.donottrackheader.enabled" = true;
      "privacy.trackingprotection.enabled" = true;
    };
  };

  # Copy textfox chrome files to LibreWolf profile
  home.file = {
    # Copy the entire chrome directory structure
    ".mozilla/librewolf/sd8mel26.default/chrome" = {
      source = "${textfoxPath}/chrome";
      recursive = true;
    };

    # # Create a config.css file for customizations
    # ".mozilla/librewolf/sd8mel26.default/chrome/config.css" = {
    #   text = ''
    #     :root {
    #       /* Textfox customizations - modify these as needed */
    #       --tf-font-family: "JetBrainsMono Nerd Font", "SF Mono", Consolas, monospace;
    #       --tf-font-size: 14px;
    #       --tf-rounding: 8px;
    #       --tf-border-width: 2px;
    #       --tf-display-titles: flex;
    #       --tf-display-horizontal-tabs: none;
    #       --tf-display-window-controls: none;
    #       --tf-display-nav-buttons: none;
    #       --tf-display-urlbar-icons: none;
    #       --tf-display-sidebar-tools: flex;
    #     }
    #   '';
    # };
  };
}
