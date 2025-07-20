{ ... } @ args:

{
  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = import ./mime-defaults.nix args;
    };
  };
}
