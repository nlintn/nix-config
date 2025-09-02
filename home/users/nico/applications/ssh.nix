{ ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = builtins.mapAttrs (_: v: { extraOptions = v; }) {
      "*" = {
        Compression = "no";
        ForwardAgent = "no";
        UserKnownHostsFile = "~/.ssh/known_hosts";
      };
      lxhalle = {
        Hostname = "halle.cit.tum.de";
        User = "lintn";
      };
      valhalla = {
        Hostname = "valhalla.fs.tum.de";
        User = "lintner";
      };
    };
  };

  services.ssh-agent.enable = true;
}
