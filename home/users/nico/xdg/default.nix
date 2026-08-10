{
  config,
  lib,
  ...
}@args:

{
  imports = [
    ./extra-session-vars.nix
    ./terminal-exec.nix
  ];

  systemd.user.tmpfiles.rules = [
    "d ${lib.escapeShellArg config.xdg.userDirs.download} - - - 1d -"
  ];

  home.preferXdgDirectories = true;

  xdg = {
    enable = true;
    localBinInPath = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;
    };
    mimeApps = {
      enable = true;
      defaultApplications = import ./mime-defaults.nix args;
    };
    configFile."mimeapps.list".force = true;
  };
}
