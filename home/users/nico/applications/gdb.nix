{ lib, pkgs, ... }:

let
  gdbinit = ''
    source ${pkgs.gdb-ptrfind}/ptrfind.py
  '';
  pkg = pkgs.gdb;
in
{
  home.packages = [
    (pkgs.symlinkJoin {
      inherit (pkg) name meta;
      paths = [ pkg ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = /* sh */ ''
        echo ${lib.escapeShellArg gdbinit} > $out/share/.gdbinit
        wrapProgram $out/bin/gdb --add-flags "-x $out/share/.gdbinit --nh"
      '';
    })
  ];
}
