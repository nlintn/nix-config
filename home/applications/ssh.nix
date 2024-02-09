{ ... }:

{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      lxhalle = {
        hostname = "lxhalle.in.tum.de";
        user = "lintn";
      };
      valhalla = {
        hostname = "valhalla.fs.tum.de";
        user = "lintner";
      };
    };
  };
}