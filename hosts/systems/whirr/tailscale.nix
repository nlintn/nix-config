{
  config,
  ...
}:

let
  cfg = config.services.tailscale;

  settings = [
    "--accept-dns=false"
  ];
  relayServerPort = 40000;
in
{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    disableUpstreamLogging = true;
    extraSetFlags = settings ++ [
      "--relay-server-port=${toString relayServerPort}"
    ];
    extraUpFlags = settings ++ [
      "--login-server"
      "https://headscale.nlintn.de"
    ];
    authKeyFile = config.age.secrets."tailscale-authkey".path;
  };

  networking.firewall.allowedUDPPorts = [ relayServerPort ];

  networking.extraHosts = "192.168.201.1 headscale.nlintn.de";

  networking.nftables.tables."ts-prohibit-wg0" = {
    family = "inet";
    content = ''
      chain output {
        type filter hook output priority -100
        oifname wg0 udp sport ${toString cfg.port} reject
        oifname wg0 udp sport ${toString relayServerPort} reject
      }
    '';
  };
}
