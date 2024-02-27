{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland; 
    profiles."nico" = {
      settings = {
        "browser.fullscreen.autohide" = false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      userChrome = ''
        :root[inFullscreen] #PersonalToolbar {
          visibility: visible !important;
        }
        .titlebar-buttonbox-container{ display:none } /* Remove close button*/ 
        .titlebar-spacer[type="post-tabs"]{ display:none }
      '';
    };
  };
}
