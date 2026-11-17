{
  config,
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
    package = pkgs.jail pkgs.element-desktop (
      combinators:
      with combinators;
      [
        (base-xdg "im.riot.Riot")
        gpu
        gui-enhanced
        inhibit-idle
        network
        notifications
        secret-service
        sys-tray
        persist-base-dirs
        shared-tmp
      ]
      ++ (lib.optional keepassxc_fdo (set-argv [
        "--password-store=gnome-libsecret"
        (noescape "\"$@\"")
      ]))
    );
  };
}
