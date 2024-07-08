{ ... }:

{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "8h";
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
  services.ssh-agent = {
    enable = true;
  };
}
