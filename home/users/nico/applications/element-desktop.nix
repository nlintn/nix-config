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
      [
        (persist-home "element-desktop")
        (shared-tmp "element-desktop")
        gpu
        gui-enhanced
        network
        notifications
        open-urls-in-browser
        secret-service
        sys-tray

        (dbus {
          portalAppId = "element-desktop";
          talk = [
            "org.freedesktop.ScreenSaver"
            "org.freedesktop.portal.Desktop"
            "org.freedesktop.portal.Documents"
          ];
        })
      ]
      ++ (lib.optional keepassxc_fdo (set-argv [
        "--password-store=gnome-libsecret"
        (noescape "\"$@\"")
      ]))
    );
  };
}
