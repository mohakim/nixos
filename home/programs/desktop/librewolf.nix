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

    # Create a config.css file for customizations to fix issue #124
    ".mozilla/librewolf/sd8mel26.default/chrome/config.css" = {
      text = ''
       
        /* Additional fixes specifically for issue #124 */
        
        /* Remove unwanted shadows and double borders from tab text */
        .tab-text, .tab-label {
          text-shadow: none !important;
          border: none !important;
          margin: 1px 2px !important; /* vertical horizontal - fine-tune as needed */
        }
        
        /* Fix URL bar text positioning and remove effects */
        #urlbar .urlbar-input {
          text-shadow: none !important;
          border: none !important;
          margin: 0px 3px !important; /* adjust horizontal spacing */
        }
        
        /* Fix main content area text objects */
        .main-content .text-object,
        .toolbar-text {
          text-shadow: none !important;
          border: none !important;
          margin: 1px 2px !important;
        }
        
        /* Remove any secondary borders that cause the "double border" effect */
        #TabsToolbar,
        #nav-bar,
        .main-window {
          box-shadow: none !important;
          border-bottom: none !important;
        }
        
        /* Ensure clean appearance for the three main sections mentioned in issue */
        #TabsToolbar .toolbar-items,
        #nav-bar .toolbar-items,
        #main-window .content-area {
          border: var(--tf-border-width) solid var(--tf-border) !important;
          border-radius: var(--tf-rounding) !important;
          box-shadow: none !important;
        }
      '';
    };
  };
}
