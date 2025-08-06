{ config, pkgs, ... }:

{
  boot.kernelParams = [ "console=tty1" ];
  services.greetd = {
    enable = true;
    vt = 2;
    settings = {
      default_session = let session_dir = "${config.services.displayManager.sessionData.desktops}/share"; in {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format \"%d. %b %Y %H:%M:%S\" --asterisks --user-menu --remember
          --remember-user-session --sessions ${session_dir}/wayland-sessions --xsessions ${session_dir}/xsessions";
      };
    };
  };
}
