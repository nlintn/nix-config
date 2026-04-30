{
  config,
  lib,
  pkgs,
  ...
}:

let
  grep = lib.getExe pkgs.gnugrep;
  systemctl = config.systemd.user.systemctlPath;

  askpass = "${pkgs.openssh-askpass}/libexec/gtk-ssh-askpass";
  askpassWrapper = pkgs.writeShellScript "ssh-askpass-wrapper" ''
    eval export $(${systemctl} --user show-environment | ${grep} -E '^(DISPLAY|WAYLAND_DISPLAY|XAUTHORITY)=')
    exec ${askpass} "$@"
  '';
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = lib.mapAttrs (_: v: { extraOptions = v; }) {
      "*" = {
        Compression = "no";
        ForwardAgent = "no";
        UserKnownHostsFile = "~/.ssh/known_hosts";
      };
    };
    includes = [ "hosts" ];
  };

  services.ssh-agent.enable = true;
  systemd.user.services.ssh-agent.Service.Environment = [
    "DISPLAY=fake"
    "SSH_ASKPASS=${askpassWrapper}"
  ];
  home.sessionVariables.SSH_ASKPASS = askpass;
}
