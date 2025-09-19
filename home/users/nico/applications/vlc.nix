{ pkgs, lib, ... }:

{
  home.packages = [(
    let
      pkg = pkgs.vlc;
    in pkgs.symlinkJoin {
      inherit (pkg) name meta;
      paths = [ pkg ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/vlc \
          --unset DISPLAY
        mv $out/share/applications/vlc.desktop{,.orig}
        substitute $out/share/applications/vlc.desktop{.orig,} \
          --replace-fail Exec=${lib.getExe pkgs.vlc} Exec=$out/bin/vlc
      '';
    }
  )];
}
