{
  config,
  lib,
  pkgs,
  ...
}:

let
  wgIfname = "wg0";
  rtTable = "201";
  fwMark = "201";
  ip = lib.getExe' pkgs.iproute2 "ip";
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
    nftables.tables."wg-routing" = {
      family = "inet";
      content = ''
        chain prerouting {
          type filter hook prerouting priority mangle; policy accept;
          iifname ${wgIfname} ct state new ct mark set ${fwMark}
        }

        chain output {
          type route hook output priority mangle; policy accept;
          ct mark ${fwMark} meta mark set ${fwMark}
        }
      '';
    };
    firewall.extraReversePathFilterRules = ''
      iifname ${wgIfname} accept
    '';
  };

  networking.wireguard.interfaces.${wgIfname} = {
    privateKeyFile = config.age.secrets."wg_whirr.key".path;
    ips = [
      "${wg.ipv4.chirrp}/24"
      "${wg.ipv6.chirrp}/120"
    ];
    table = rtTable;
    allowedIPsAsRoutes = true;
    postSetup = ''
      ${ip} -4 rule add fwmark ${fwMark} table ${rtTable} priority 1
      ${ip} -6 rule add fwmark ${fwMark} table ${rtTable} priority 1
    '';
    preShutdown = ''
      ${ip} -4 rule del fwmark ${fwMark} table ${rtTable} priority 1
      ${ip} -6 rule del fwmark ${fwMark} table ${rtTable} priority 1
    '';
    dynamicEndpointRefreshSeconds = 300;
    peers = [
      {
        name = "whirr";
        publicKey = "6T4vjixxXBJRPUOzL7mLhXWQdUwhUaxE0/iyEaJykho=";
        presharedKeyFile = config.age.secrets."chirrp_whirr-wg_psk.key".path;
        persistentKeepalive = 25;
        allowedIPs = [
          "${wg.ipv4.whirr}/32"
          "${wg.ipv6.whirr}/128"
          "0.0.0.0/0"
          "::/0"
        ];
        endpoint = "whirr.${config.web.primaryDomain}:51820";
      }
    ];
  };
}
