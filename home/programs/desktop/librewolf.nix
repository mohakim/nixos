# LibreWolf with Textfox configuration
{ pkgs, textfox, ... }:

{
  imports = [
    textfox.homeManagerModules.default
  ];

  home.packages = [ pkgs.librewolf ];

  # Textfox configuration
  textfox = {
    enable = true;
    profile = "sd8mel26.default";
    config = {
      displayNavButtons = true;
      font = {
        family = "JetBrainsMono Nerd Font";
        size = "16px";
      };

      extraConfig = ''
        /* Fix border colors for proper contrast */
        :root {
          /* Make default border match text color for better contrast */
          --tf-border: var(--lwt-text-color, currentColor) !important;
          --tf-accent: var(--toolbarbutton-icon-fill) !important;
        }
      
        /* Ensure all sections start with muted text-color border */
        #TabsToolbar,
        #nav-bar,
        #tabbrowser-tabbox,
        #PersonalToolbar,
        #sidebar-box {
          border-color: var(--tf-border) !important;
          transition: border-color var(--tf-border-transition) !important;
        }
      
        /* Only apply accent on actual hover/focus */
        #TabsToolbar:hover,
        #TabsToolbar:focus-within,
        #nav-bar:hover, 
        #nav-bar:focus-within,
        #tabbrowser-tabbox:hover,
        #tabbrowser-tabbox:focus-within,
        #PersonalToolbar:hover,
        #PersonalToolbar:focus-within,
        #sidebar-box:hover,
        #sidebar-box:focus-within {
          border-color: var(--tf-accent) !important;
        }
      
        /* Completely reset urlbar styling - no borders when inactive */
        #urlbar-container {
          border: none !important;
          background: transparent !important;
        }
      
        #urlbar {
          border: none !important;
          border-radius: var(--tf-rounding) !important;
          background-color: transparent !important;
          transition: border-color var(--tf-border-transition) !important;
          /* Prevent any positioning changes when typing */
          position: static !important;
          top: auto !important;
          left: auto !important;
          transform: none !important;
          margin: 0 !important;
        }
      
        #urlbar[breakout][breakout-extend] {
          width: var(--urlbar-width) !important;
          height: var(--urlbar-height) !important;
        }

        #urlbar[breakout][breakout-extend],
        #urlbar[breakout][breakout-extend-disabled][open] {
          height: var(--urlbar-height);
        }
      
        /* Active urlbar - ONLY text-colored border, never accent */
        #urlbar:focus-within,
        #urlbar[focused] {
          border: var(--tf-border-width) solid var(--tf-border) !important;
          /* Explicitly prevent any accent color bleeding */
          box-shadow: none !important;
          outline: none !important;
          /* Ensure no position changes even when focused */
          position: static !important;
          top: auto !important;
          left: auto !important;
          transform: none !important;
        }
      
        /* Hide urlbar suggestions/dropdown completely */
        .urlbarView,
        #urlbar .urlbarView,
        #urlbar-results,
        .urlbar-results {
          display: none !important;
          visibility: hidden !important;
        }
      
        /* Aggressively remove any other borders that might be causing double-border effect */
        #urlbar:focus-within *,
        #urlbar[focused=""] * {
          border: none !important;
          box-shadow: none !important;
          outline: none !important;
        }
      
        /* Force remove any inherited accent styling from navbar hover */
        #nav-bar:hover #urlbar,
        #nav-bar:focus-within #urlbar {
          border-color: var(--tf-border) !important;
        }
      
        #nav-bar:hover #urlbar:focus-within,
        #nav-bar:focus-within #urlbar:focus-within,
        #nav-bar:hover #urlbar[focused],
        #nav-bar:focus-within #urlbar[focused] {
          border-color: var(--tf-border) !important;
        }

        #identity-box {
          display: none;
        }

        #urlbar-go-button {
          display: none;
        }
      
        /* Remove conflicting urlbar background styling */
        #urlbar-background {
          background-color: transparent !important;
          border: none !important;
          box-shadow: none !important;
        }
     
        /* Fix for issue #124 - Title positioning */
        #tabbrowser-tabbox::before {
          margin: -1.398rem 0.5rem !important;
          text-shadow: none !important;
          top: auto !important;
          transform: translateY(0) !important;
        }
      
        /* Ensure title colors match border states */
        #TabsToolbar::before,
        #nav-bar::before,
        #tabbrowser-tabbox::before,
        #PersonalToolbar::before,
        #sidebar-box::before {
          color: var(--lwt-text-color);
          transition: color var(--tf-border-transition);
        }
      
        #TabsToolbar:hover::before,
        #nav-bar:hover::before,
        #tabbrowser-tabbox:hover::before,
        #PersonalToolbar:hover::before,
        #sidebar-box:hover::before {
          color: var(--tf-accent);
        }
      '';
    };
  };

  # Copy textfox files from firefox to librewolf directory
  home.activation.copyTextfoxToLibrewolf = ''
    FIREFOX_DIR="$HOME/.mozilla/firefox/sd8mel26.default"
    LIBREWOLF_DIR="$HOME/.mozilla/librewolf/sd8mel26.default"

    if [ -d "$FIREFOX_DIR" ]; then
      echo "Copying textfox files from Firefox to LibreWolf..."

      # Create librewolf directory if it doesn't exist
      mkdir -p "$LIBREWOLF_DIR"

      # Copy all contents from firefox profile to librewolf profile
      cp -r "$FIREFOX_DIR"/* "$LIBREWOLF_DIR/" 2>/dev/null || true

      # Remove the firefox directory
      rm -rf "$HOME/.mozilla/firefox"

      echo "Textfox files copied to LibreWolf and Firefox directory removed."
    fi
  '';

  # XDG MIME associations for LibreWolf
  xdg.mimeApps.defaultApplications = {
    "text/html" = "librewolf.desktop";
    "x-scheme-handler/http" = "librewolf.desktop";
    "x-scheme-handler/https" = "librewolf.desktop";
    "x-scheme-handler/about" = "librewolf.desktop";
    "x-scheme-handler/unknown" = "librewolf.desktop";
    "application/pdf" = "librewolf.desktop";
  };
}
