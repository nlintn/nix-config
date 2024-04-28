{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland; 
    profiles."nico" = {
      settings = {
        "browser.download.autohideButton" = false;
        "browser.fullscreen.autohide" = false;
        "browser.tabs.closeWindowWithLastTab" = false;
        "media.ffmpeg.vaapi.enabled" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      userChrome = /* css */ ''
        :root[inFullscreen] #PersonalToolbar {
          visibility: visible !important;
        }
        .titlebar-buttonbox-container{ display:none } /* Remove close button */ 
        .titlebar-spacer[type="post-tabs"]{ display:none }
      '';
    };
  };
}
