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
    package = lib.mkIf (config.services.gnome-keyring.enable || keepassxc_fdo) (
      let
        pkg = pkgs.element-desktop;
      in
      pkgs.symlinkJoin {
        inherit (pkg) name meta;
        paths = [ pkg ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = "wrapProgram $out/bin/element-desktop --add-flags --password-store=gnome-libsecret";
      }
    );
  };
}
