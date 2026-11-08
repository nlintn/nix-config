{
  config,
  lib,
  pkgs,
  specialArgs,
  ...
}:

let
  name = "aria2";
  inherit (config.vars.containerSettings.ids.${name})
    rootUID
    localAddress
    localAddress6
    ;
  inherit (config.vars.containerSettings) hostAddress hostAddress6;
  hostConfig = config;
  shareGroup = config.vars.shareGroup;
  shareGroupGID = config.users.groups.${shareGroup}.gid;
  secrets = with config.age.secrets; {
    rpc = aria2-rpc_secret.path;
    wg = aria2-wg_conf.path;
  };

  cfg = config.containers.${name};
in
{
  age.secrets = {
    "aria2-rpc_secret".owner = toString rootUID;
    "aria2-wg_conf".owner = toString rootUID;
  };

  systemd.tmpfiles.rules = [
    "d ${lib.escapeShellArg "${config.vars.shareDir}/downloads"} 7770 filebrowser ${shareGroup} -"
  ];

  containers.${name} = {
    inherit
      hostAddress
      localAddress
      hostAddress6
      localAddress6
      ;
    autoStart = true;
    privateUsers = rootUID;
    privateNetwork = true;
    # ephemeral = true;
    extraFlags = [
      "--link-journal=try-host"
      "--private-users-ownership=auto"
    ];
    bindMounts = lib.mkMerge [
      {
        "/downloads:idmap" = {
          hostPath = "${config.vars.shareDir}/downloads";
          isReadOnly = false;
        };
      }
      (lib.mapAttrs (_: v: {
        mountPoint = "${v}";
        hostPath = v;
        isReadOnly = true;
      }) secrets)
    ];

    inherit specialArgs;
    config =
      {
        config,
        lib,
        ...
      }:
      {
        nixpkgs.pkgs = pkgs;
        nix = {
          inherit (hostConfig.nix)
            registry
            nixPath
            channel
            settings
            ;
        };

        users.users.aria2.uid = lib.mkForce hostConfig.users.users.filebrowser.uid;
        users.groups.aria2.gid = lib.mkForce shareGroupGID;

        services.aria2 = {
          enable = true;
          rpcSecretFile = secrets.rpc;
          downloadDirPermission = "0775";
          serviceUMask = "0007";
          settings = {
            disable-ipv6 = true;
            rpc-listen-all = true;
            dir = "/downloads";
            file-allocation = "falloc";
            check-integrity = true;
            continue = true;
            remote-time = true;
            max-concurrent-downloads = 50;
            seed-ratio = 1;
            seed-time = 15;
            check-certificate = true;
            http-accept-gzip = true;
            max-tries = 10;
            retry-wait = 10;
            content-disposition-default-utf8 = true;
            user-agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3602.2 Safari/537.36";
            save-session = "/var/lib/aria2/aria2.session";
            input-file = "/var/lib/aria2/aria2.session";
            bt-save-metadata = true;
            bt-load-saved-metadata = true;
            bt-remove-unselected-file = true;
            reuse-uri = false;
            no-netrc = true;
          };
        };
        systemd.services.aria2 = {
          bindsTo = [ "wg-quick-wg0.service" ];
          after = [ "wg-quick-wg0.service" ];
        };

        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [ config.services.aria2.settings.rpc-listen-port ];
          };
          nftables.enable = true;
          useHostResolvConf = lib.mkForce false;
          nameservers = [
            hostAddress
            hostAddress6
          ];
          wg-quick.interfaces.wg0 = {
            configFile = secrets.wg;
          };
        };

        system.stateVersion = hostConfig.system.stateVersion;
      };
  };

  web.sites."vpn.aria2" = {
    aliases = [ "vpn.aria" ];
    restrictAccess = {
      auth.enable = true;
      origin.enable = true;
    };
    locations = {
      "/".nginxConfig = {
        root = "${pkgs.ariang}/share/ariang";
        tryFiles = "$uri $uri/ =404";
      };
      "/jsonrpc" = {
        reverseProxy = "${cfg.localAddress}:${toString cfg.config.services.aria2.settings.rpc-listen-port}/jsonrpc";
        nginxConfig.proxyWebsockets = true;
      };
    };
  };
}
