{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland; 
    profiles."nico" = {
      userChrome = ''
        :root[inFullscreen] #PersonalToolbar {
          visibility: visible !important;
        }
      '';
    };
  };
}
