{ config, lib, pkgs, ... } @ args:

{
  imports = [
    ./terminal-exec.nix
  ];

  home.activation.tmpDirs = lib.hm.dag.entryBetween [ "linkGeneration" "createXdgUserDirectories" ] [ "writeBoundary" ] ''
    ${lib.getExe' pkgs.coreutils "rm"} -rf ${config.xdg.userDirs.download};
    TMPDIR=''${TMPDIR:-/tmp}
    ${lib.getExe' pkgs.coreutils "mkdir"} -p "$TMPDIR/download$UID" &&
    ${lib.getExe' pkgs.coreutils "ln"} -s "$TMPDIR/download$UID" ${config.xdg.userDirs.download}
  '';

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_PROJECT_DIR = "${config.home.homeDirectory}/Projects";
      };
    };
    mimeApps = {
      enable = true;
      defaultApplications = import ./mime-defaults.nix args;
    };
    configFile."mimeapps.list".force = true;
  };
}
