{
  config,
  lib,
  pkgs,
  ...
}:

let
  genCfgDest = "${config.xdg.configHome}/hypr/gen-monitors.lua";
  pkg = pkgs.hyprmon;
in
{
  home.packages = [
    (pkgs.symlinkJoin {
      inherit (pkg) name meta;
      paths = [ pkg ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = /* sh */ ''
        wrapProgram $out/bin/hyprmon --set HYPRLAND_CONFIG ${lib.escapeShellArg genCfgDest}
      '';
    })
  ];

  wayland.windowManager.hyprland.extraConfig = "require(\"gen-monitors\")";

  systemd.user.tmpfiles.rules = [ "f ${lib.escapeShellArg genCfgDest} - - - - -" ];
}
