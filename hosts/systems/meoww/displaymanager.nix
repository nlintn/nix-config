{ config, pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = let session_dir = "${config.services.displayManager.sessionData.desktops}/share"; in {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --time-format \"%d. %b %Y %H:%M:%S\" --asterisks --user-menu --remember
          --remember-user-session --sessions ${session_dir}/wayland-sessions --xsessions ${session_dir}/xsessions";
      };
    };
  };
}
