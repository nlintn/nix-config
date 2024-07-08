{ pkgs, ... }:

{
  programs.librewolf = {
    enable = true;
    package = pkgs.librewolf-wayland; 
    settings = {
      "browser.download.autohideButton" = false;
      "browser.fullscreen.autohide" = false;
      "browser.tabs.closeWindowWithLastTab" = false;
      "identity.fxaccounts.enabled" = true;
      "media.ffmpeg.vaapi.enabled" = true;
      "privacy.resistFingerprinting" = false;
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    };
  };
  home.file.".librewolf/profiles.ini".text = ''
    [General]
    StartWithLastProfile=1

    [Profile0]
    Name=nico
    IsRelative=1
    Path=nico
    Default=1
  '';
  home.file.".librewolf/nico/chrome/userChrome.css".text = /* css */ ''
    :root[inFullscreen] #PersonalToolbar {
      visibility: visible !important;
    }
    .titlebar-buttonbox-container{ display:none } /* Remove close button */ 
    .titlebar-spacer[type="post-tabs"]{ display:none }
  '';
}
