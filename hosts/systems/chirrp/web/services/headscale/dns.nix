{
  config,
  lib,
  pkgs,
  ...
}:

let
  dynRecordsFile =
    config.web.sites
    |> lib.filterAttrs (_: v: v.genMagicDnsEntry)
    |> lib.mapAttrsToList (
      _: v:
      lib.map (d: [
        {
          name = d;
          type = "A";
          value = "";
        }
        {
          name = d;
          type = "AAAA";
          value = "";
        }
      ]) v.allDomains
    )
    |> lib.flatten
    |> lib.toJSON
    |> pkgs.writeText "dyn-records";

  staticRecordsFile =
    [
    ]
    |> lib.toJSON
    |> pkgs.writeText "static-records";
in
{
  systemd.services.headscale-extra-records = {
    wants = [ config.systemd.services.tailscaled-autoconnect.name ];
    after = [ config.systemd.services.tailscaled-autoconnect.name ];
    wantedBy = [ config.systemd.targets.multi-user.name ];
    serviceConfig = {
      Type = "oneshot";
      StateDirectory = "headscale";
      User = config.systemd.services.headscale.serviceConfig.User;
      Group = config.systemd.services.headscale.serviceConfig.Group;
    };
    path = [
      config.services.tailscale.package
      pkgs.jq
    ];
    enableStrictShellChecks = true;
    script = ''
      IPV4=$(tailscale ip --4)
      IPV6=$(tailscale ip --6)
      jq -cs --arg ipv4 "$IPV4" --arg ipv6 "$IPV6" ' (.[0] | map(.value = {A: $ipv4, AAAA: $ipv6}[.type])) + .[1] ' ${dynRecordsFile} ${staticRecordsFile} > ${config.services.headscale.settings.dns.extra_records_path}
    '';
  };
}
