{
  config,
  lib,
  ...
}:

let
  cfg = config.networking;

  extInterface = "ens6";
  wgInterface = "wg0";

  wg = rec {
    prefix4 = "192.168.201.";
    prefix6 = "fd00:ff::";
    suffix = {
      whirr = 254;
      chirrp = 1;
    };
    ipv4 = lib.mapAttrs (_: v: prefix4 + toString v) suffix;
    ipv6 = lib.mapAttrs (_: v: prefix6 + lib.toHexString v) suffix;
  };
in
{
  networking = {
    useDHCP = true;
    firewall = {
      enable = true;
      allowedUDPPorts = [ cfg.wireguard.interfaces.${wgInterface}.listenPort ];
      filterForward = true;
    };
    nftables = {
      enable = true;
      flushRuleset = true;
    };

    nat = {
      enable = true;
      enableIPv6 = true;
      externalInterface = extInterface;
      internalInterfaces = [ wgInterface ];
      forwardPorts = [
        {
          destination = "${wg.ipv4.chirrp}:80";
          proto = "tcp";
          sourcePort = 80;
        }
        {
          destination = "[${wg.ipv6.chirrp}]:80";
          proto = "tcp";
          sourcePort = 80;
        }
        {
          destination = "${wg.ipv4.chirrp}:443";
          proto = "tcp";
          sourcePort = 443;
        }
        {
          destination = "[${wg.ipv6.chirrp}]:443";
          proto = "tcp";
          sourcePort = 443;
        }
      ];
    };
    nftables.tables.mss-clamp = {
      family = "inet";
      content = ''
        chain forward {
          type filter hook forward priority mangle;
          policy accept;

          iifname "${extInterface}" oifname "${wgInterface}" tcp flags & (syn|rst) == syn tcp option maxseg size set rt mtu
          iifname "${wgInterface}" oifname "${extInterface}" tcp flags & (syn|rst) == syn tcp option maxseg size set rt mtu
        }
      '';
    };

    wireguard.interfaces.${wgInterface} = {
      listenPort = 51820;
      privateKeyFile = config.age.secrets."wg-key".path;
      ips = [
        "${wg.ipv4.whirr}/24"
        "${wg.ipv6.whirr}/120"
      ];
      allowedIPsAsRoutes = true;
      peers = [
        {
          publicKey = "jFN4gAvE/JXtg201o2MqMk3PfI87v1DTpojc5+SE8Gc=";
          presharedKeyFile = config.age.secrets."chirrp_whirr-wg_psk.key".path;
          persistentKeepalive = 25;
          allowedIPs = [
            "${wg.ipv4.chirrp}/32"
            "${wg.ipv6.chirrp}/128"
          ];
        }
      ];
    };
  };
}
