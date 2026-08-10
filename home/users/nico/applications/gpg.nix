{
  config,
  osConfig ? null,
  pkgs,
  ...
}:

{
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
    scdaemonSettings = {
      disable-ccid = (osConfig.services.pcscd.enable or false);
    };
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-gnome3;
  };

  dbus.packages = [ pkgs.gcr ]; # necessary for `pinentry-gnome3`
}
