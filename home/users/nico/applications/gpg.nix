{ osConfig, pkgs, ... }:

{
  programs.gpg = {
    enable = true;
    scdaemonSettings = {
      disable-ccid = (osConfig.services.pcscd.enable or false);
    };
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-gnome3;
  };

  dbus.packages = [ pkgs.gcr ];
}
