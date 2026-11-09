{
  config,
  jail,
  lib,
  pkgs,
  ...
}:

let
  keepassxc_fdo =
    config.programs.keepassxc.enable
    && config.programs.keepassxc.settings ? FdoSecrets
    && config.programs.keepassxc.settings.FdoSecrets.Enabled or false;
in
{
  programs.element-desktop = {
    enable = true;
    package = jail pkgs.element-desktop (
      with jail.combinators;
      let
        id = "im.riot.Riot";
      in
      [
        (persist-home id)
        (shared-tmp id)
        gpu
        gui-enhanced
        inhibit-idle
        network
        notifications
        open-urls-in-browser
        secret-service
        sys-tray
        (desktop-portal id)
      ]
      ++ (lib.optional keepassxc_fdo (set-argv [
        "--password-store=gnome-libsecret"
        (noescape "\"$@\"")
      ]))
    );
  };
}
