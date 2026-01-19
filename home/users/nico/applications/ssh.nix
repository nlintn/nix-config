{ config, ... }:

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
    };
    includes = [ "hosts" ];
  };

  services.ssh-agent.enable = true;
}
