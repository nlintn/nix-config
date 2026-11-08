{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.tailscale;

  settings = [
    "--accept-dns=false"
    "--advertise-exit-node"
    "--advertise-routes=10.128.0.0/9,192.168.188.0/24"
    "--netfilter-mode=off"
  ];
in
{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    disableUpstreamLogging = true;
    useRoutingFeatures = "server";
    extraSetFlags = settings ++ [
    ];
    extraUpFlags = settings ++ [
      "--login-server"
      config.web.sites.headscale.url
    ];
  };
  networking = {
    nat = {
      enable = true;
      enableIPv6 = true;
      internalInterfaces = [ cfg.interfaceName ];
      externalInterface = "enp0s25";
    };
    nftables.tables."ts-reject-wrong-interface" = {
      family = "inet";
      content =
        let
          inherit (config.services.headscale.settings.prefixes) v4 v6;
        in
        ''
          chain input {
            type filter hook input priority filter - 1;
            iifname != ${config.services.tailscale.interfaceName} ip saddr ${v4} ${lib.optionalString config.networking.firewall.logRefusedPackets "log prefix \"refused packet: \" level info"} drop
            iifname != ${config.services.tailscale.interfaceName} ip6 saddr ${v6} ${lib.optionalString config.networking.firewall.logRefusedPackets "log prefix \"refused packet: \" level info"} drop
          }
        '';
    };
  };

  systemd.services.tailscaled-autoconnect = lib.mkIf config.services.headscale.enable {
    after = [
      config.systemd.services.tailscaled.name
      config.systemd.services.headscale.name
    ];
    wants = [
      config.systemd.services.tailscaled.name
      config.systemd.services.headscale.name
    ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "notify";
    };
    path = [
      cfg.package
      pkgs.jq
      config.services.headscale.package
    ];
    enableStrictShellChecks = true;
    script = ''
      set -euo pipefail
      getState() {
        tailscale status --json --peers=false | jq -r '.BackendState'
      }

      lastState=""
      while state="$(getState)"; do
        if [[ "$state" != "$lastState" ]]; then
          # https://github.com/tailscale/tailscale/blob/v1.72.1/ipn/backend.go#L24-L32
          case "$state" in
            NeedsLogin|NeedsMachineAuth|Stopped)
              echo "Server needs authentication, sending auth key"
              tailscale up --auth-key "$(headscale preauthkeys create --tags tag:server)" ${lib.escapeShellArgs cfg.extraUpFlags}
              ;;
            Running)
              echo "Tailscale is running"
              systemd-notify --ready
              exit 0
              ;;
            *)
              echo "Waiting for Tailscale State = Running or systemd timeout"
              ;;
          esac
          echo "State = $state"
        fi
        lastState="$state"
        sleep .5
      done
    '';
  };
}
