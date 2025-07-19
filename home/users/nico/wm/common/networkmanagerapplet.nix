{ pkgs, ... }:

{
  systemd.user.services."networkmanagerapplet" = {
    Install.WantedBy = [ "graphical-session.target" ];

    Service = {
      ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
      Restart = "always";
      RestartSec = 10;
    };
  };
  home.packages = [ pkgs.networkmanagerapplet ];
}
