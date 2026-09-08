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
    settings = {
      "Host *" = {
        AddKeysToAgent = "confirm 8h";
        Compression = "no";
        ForwardAgent = "no";
        UserKnownHostsFile = "~/.ssh/known_hosts";

        ControlMaster = "auto";
        ControlPath = "\${XDG_RUNTIME_DIR}/ssh-mux-%C";
        ControlPersist = "30s";
      };
    };
    extraOptionOverrides = {
      CheckHostIP = "yes";
      StrictHostKeyChecking = "ask";
      UpdateHostKeys = "ask";
      VerifyHostKeyDNS = "ask";
    };
    includes = [ "hosts" ];
  };

  services.ssh-agent.enable = true;
  systemd.user.services.ssh-agent.Service.Environment = [
    "DISPLAY=fake"
    "SSH_ASKPASS=${askpassWrapper}"
  ];
  home.sessionVariables.SSH_ASKPASS = askpass;

  home.sessionVariables.NIX_SSHOPTS =
    [
      "ControlMaster"
      "ControlPath"
      "ControlPersist"
    ]
    |> lib.map (o: "-o ${o}=${config.programs.ssh.settings."Host *".data.${o}}")
    |> lib.concatStringsSep " ";
}
