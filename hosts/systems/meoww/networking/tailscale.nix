{
  config,
  ...
}:

{
  services.tailscale = {
    enable = true;
    openFirewall = true;
    disableUpstreamLogging = true;
    extraSetFlags = [
      "--accept-routes"
      "--operator=nico"
    ];
    useRoutingFeatures = "client";
  };

  networking.firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ];
}
