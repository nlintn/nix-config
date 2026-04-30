{
  config,
  lib,
  pkgs,
  ...
}:

let
  genCfgDest = "${config.xdg.configHome}/hypr/gen-monitors.conf";
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

  wayland.windowManager.hyprland.settings.source = [ genCfgDest ];
}
