{ ... }:

{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      lxhalle = {
        hostname = "lxhalle.in.tum.de";
        user = "lintn";
      };
    };
  };
}