{ pkgs, ... }:

{
  systemd.user.services."wayland-pipewire-idle-inhibit" = {
    Install.WantedBy = [ "graphical-session.target" ];

    Service = {
      ExecStart = "${pkgs.wayland-pipewire-idle-inhibit}/bin/wayland-pipewire-idle-inhibit";
      Restart = "always";
      RestartSec = 10;
    };
  };
}
