{ config, ... }@args:

{
  imports = [
    ./terminal-exec.nix
  ];

  systemd.user.tmpfiles.rules = [
    ''d  "${config.xdg.userDirs.download}"  -  -  -  1d  -''
  ];

  home.preferXdgDirectories = true;

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_SOURCE_DIR = "${config.home.homeDirectory}/Sources";
      };
    };
    mimeApps = {
      enable = true;
      defaultApplications = import ./mime-defaults.nix args;
    };
    configFile."mimeapps.list".force = true;
  };
}
