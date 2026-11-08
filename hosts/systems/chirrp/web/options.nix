{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkOption types;
  cfg = config.web;
in
{
  options.web = {
    primaryDomain = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    extraDomains = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
    allDomains = mkOption {
      type = types.listOf types.str;
      default = config.web.sites |> lib.mapAttrsToList (_: v: v.allDomains) |> lib.flatten;
      readOnly = true;
    };
    defaultAuthConfig = mkOption {
      type = types.attrs;
      default = { };
    };
    defaultOriginAllow = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
    defaultOriginDeny = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
    defaultRobotsTxtContent = mkOption {
      type = types.lines;
      default = "";
    };
    sites = mkOption {
      type = types.attrsOf (
        types.submodule (
          { config, name, ... }: {
            options = {
              name = mkOption {
                type = types.str;
                default = name;
              };
              aliases = mkOption {
                type = types.listOf types.str;
                default = [ ];
              };
              domain = mkOption {
                type = types.str;
                default = "${config.name}.${cfg.primaryDomain}";
              };
              extraDomains = mkOption {
                type = types.listOf types.str;
                default =
                  [
                    ([ config.name ] ++ config.aliases)
                    ([ cfg.primaryDomain ] ++ cfg.extraDomains)
                  ]
                  |> lib.crossLists (x: y: "${x}.${y}")
                  |> lib.tail;
              };
              allDomains = mkOption {
                type = types.listOf types.str;
                default = [ config.domain ] ++ config.extraDomains;
                readOnly = true;
              };
              genMagicDnsEntry = mkOption {
                type = types.bool;
                default = true;
              };
              ssl = mkOption {
                type = types.bool;
                default = true;
              };
              genCert = mkOption {
                type = types.bool;
                default = true;
              };
              maintenance = mkOption {
                type = types.bool;
                default = false;
              };
              restrictAccess = {
                auth = {
                  enable = mkOption {
                    type = types.bool;
                    default = false;
                  };
                  config = mkOption {
                    type = types.attrs;
                    default = cfg.defaultAuthConfig;
                  };
                };
                origin = {
                  enable = mkOption {
                    type = types.bool;
                    default = false;
                  };
                  allow = mkOption {
                    type = types.listOf types.str;
                    default = cfg.defaultOriginAllow;
                  };
                  deny = mkOption {
                    type = types.listOf types.str;
                    default = cfg.defaultOriginDeny;
                  };
                };
                satisfy = mkOption {
                  type = types.enum [
                    "any"
                    "all"
                  ];
                  default = "any";
                };
              };
              reverseProxy = mkOption {
                type = types.nullOr (types.either types.port (types.either types.path types.str));
                default = null;
              };
              locations = mkOption {
                type = types.attrsOf (
                  types.submodule {
                    options = {
                      reverseProxy = mkOption {
                        type = types.nullOr (types.either types.port (types.either types.path types.str));
                        default = config.reverseProxy;
                      };
                      localhostOnly = mkOption {
                        type = types.bool;
                        default = false;
                      };
                      authExclude = mkOption {
                        type = types.bool;
                        default = false;
                      };
                      originExclude = mkOption {
                        type = types.bool;
                        default = false;
                      };
                      nginxConfig = mkOption {
                        type = types.attrs;
                        default = { };
                      };
                    };
                  }
                );
                default = { };
              };
              robotsTxt = {
                enable = mkOption {
                  type = types.bool;
                  default = true;
                };
                content = mkOption {
                  type = lib.types.lines;
                  default = cfg.defaultRobotsTxtContent;
                };
              };
              nginxConfig = mkOption {
                type = types.attrs;
                default = { };
              };
              accessLog = mkOption {
                type = types.nullOr types.path;
                default = "/var/log/nginx/${config.domain}_access.log";
              };
              errorLog = mkOption {
                type = types.nullOr types.path;
                default = "/var/log/nginx/${config.domain}_error.log";
              };
              url = mkOption {
                type = types.nullOr types.str;
                default = lib.head config.allUrls;
                readOnly = true;
              };
              allUrls = mkOption {
                type = types.listOf types.str;
                default = lib.map (d: (if config.ssl then "https://" else "http://") + d) config.allDomains;
                readOnly = true;
              };
            };
            config = {
              locations = {
                "/" = lib.mkIf (config.reverseProxy != null) { };
                "= /robots.txt" = lib.mkIf config.robotsTxt.enable (
                  lib.mkDefault {
                    reverseProxy = null;
                    nginxConfig.root = pkgs.writeTextDir "robots.txt" config.robotsTxt.content;
                    authExclude = true;
                    originExclude = true;
                  }
                );
              };
            };
          }
        )
      );
    };

    basePort = mkOption {
      type = types.port;
      default = 4096;
    };
    ports = mkOption {
      type = types.attrsOf (types.nullOr types.port);
      default = { };
      apply =
        assigns:
        let
          staticAssigns = lib.filterAttrs (_: p: p != null) assigns;
          staticAssignedPorts = lib.attrValues staticAssigns;
          nextPort = port: if lib.elem (port + 1) staticAssignedPorts then nextPort (port + 1) else port + 1;
        in
        staticAssigns
        //
          lib.listToAttrs
            (lib.foldl
              ({ acc, p }: n: {
                acc = acc ++ [ (lib.nameValuePair n p) ];
                p = nextPort p;
              })
              {
                acc = [ ];
                p = cfg.basePort;
              }
              (lib.filterAttrs (_: p: p == null) assigns |> lib.attrNames)
            ).acc;
    };

    udsDir = mkOption {
      type = types.str;
      default = "/run/uds";
    };
    uds = mkOption {
      type = types.attrsOf (
        types.submodule (
          { config, name, ... }: {
            options = {
              dir = mkOption {
                type = types.str;
                default = "${cfg.udsDir}/${name}";
              };
              path = mkOption {
                type = types.path;
                default = "${config.dir}/${name}.sock";
              };
              serviceName = mkOption {
                type = types.nullOr types.str;
                default = name;
              };
              group = mkOption {
                type = types.str;
                default = "uds-${name}";
              };
              nginxAddGroup = mkOption {
                type = types.bool;
                default = true;
              };
              srvAddGroup = mkOption {
                type = types.bool;
                default = true;
              };
              srvAddBindPath = mkOption {
                type = types.bool;
                default = true;
              };
            };
          }
        )
      );
      default = { };
    };
  };

  config = {
    assertions = lib.mkMerge [
      [
        {
          assertion = cfg.ports |> lib.attrValues |> lib.allUnique;
          message = "ports not unique";
        }
        {
          assertion = lib.attrValues cfg.uds |> lib.map (v: v.path) |> lib.allUnique;
          message = "socket paths not unique";
        }
        {
          assertion =
            lib.attrValues cfg.uds
            |> lib.foldl (acc: v: acc // { ${v.path} = acc.${v.path} or [ ] ++ [ v.group ]; }) { }
            |> lib.attrValues
            |> lib.all (x: lib.length x == 1);
          message = "socket dirs don't have same group for same dir";
        }
      ]
    ];

    users.groups = lib.mapAttrs' (_: v: lib.nameValuePair v.group { }) config.web.uds;
    systemd.tmpfiles.settings.uds = lib.mapAttrs' (
      _: v:
      lib.nameValuePair v.dir {
        "d" = {
          mode = "3770";
          user = "root";
          group = v.group;
        };
      }
    ) config.web.uds;
    systemd.services =
      lib.attrValues config.web.uds
      |> lib.map (v: {
        ${v.serviceName} = {
          serviceConfig = {
            BindPaths = lib.mkIf v.srvAddBindPath [ v.dir ];
            SupplementaryGroups = lib.mkIf v.srvAddGroup [ v.group ];
          };
        };
      })
      |> lib.mkMerge;
  };
}
