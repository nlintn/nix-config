{ pkgs, ... }:

{
  systemd.user.services."polkit-gnome-authentication-agent" = {
    Install.WantedBy = [ "graphical-session.target" ];

    Service = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "always";
      RestartSec = 10;
    };
  };
}
