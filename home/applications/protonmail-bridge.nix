{ pkgs, ... }:

let
  unitName = "protonmail-bridge";
  pkg = pkgs.protonmail-bridge;
  cfgScript = pkgs.writeScriptBin "protonmail-bridge-cfg" /* sh */ ''
    systemctl --user stop ${unitName}.service && \
    ${pkg}/bin/protonmail-bridge --cli; \
    systemctl --user restart ${unitName}.service
  '';
in {
  systemd.user.services.${unitName} = {
    Install.WantedBy = [ "graphical-session.target" ];

    Service = {
      ExecStart = "${pkg}/bin/protonmail-bridge -n";
      Restart = "always";
    };
  };
  home.packages = [ pkg cfgScript ];
}
