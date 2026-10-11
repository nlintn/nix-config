{
  ...
}:

{
  imports = [
    ./dns.nix
    ./tailscale.nix
  ];

  networking = {
    usePredictableInterfaceNames = false;

    networkmanager = {
      enable = true;
      wifi.powersave = true;
    };

    firewall.enable = true;
    nftables.enable = true;
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}
