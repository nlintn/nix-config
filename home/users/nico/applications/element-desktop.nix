{ config, lib, pkgs, ... }:

{
  programs.element-desktop = {
    enable = true;
    package = lib.mkIf (config.services.gnome-keyring.enable || config.programs.keepassxc.enable) (let
      pkg = pkgs.element-desktop;
    in pkgs.symlinkJoin {
      inherit (pkg) name meta;
      paths = [ pkg ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = "wrapProgram $out/bin/element-desktop --add-flags --password-store=gnome-libsecret";
    });
  };
}
