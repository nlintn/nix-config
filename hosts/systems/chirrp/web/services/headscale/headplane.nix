{
  config,
  pkgs-unstable,
  ...
}:

let
  clientSecretFile = "headplane-client_secret";
  cookieSecretFile = "headplane-cookie_secret";

  apiKeyfile = "key";
  apiStateDir = "headplane/apikey";

  headplaneSrv = config.systemd.services.headplane;
  headscaleSrv = config.systemd.services.headscale;
in
{
  disabledModules = [ "services/networking/headplane.nix" ]; # TODO: remove after 26.11
  imports = [ "${pkgs-unstable.path}/nixos/modules/services/networking/headplane.nix" ];

  age.secrets.${clientSecretFile}.owner = headplaneSrv.serviceConfig.User;
  age.secrets.${cookieSecretFile}.owner = headplaneSrv.serviceConfig.User;

  web.ports.headplane = null;

  services.headplane = {
    enable = true;
    package = pkgs-unstable.headplane;
    agent.package = pkgs-unstable.headplane-agent;
    settings = {
      server = {
        host = "127.0.0.1";
        port = config.web.ports.headplane;
        base_url = config.web.sites.headplane.url;
        cookie_secret_path = config.age.secrets.${cookieSecretFile}.path;
        cookie_secure = true;
        cookie_domain = config.web.sites.headplane.domain;
      };
      headscale = {
        url = config.web.sites.headscale.url;
        api_key_path = "/var/lib/${apiStateDir}/${apiKeyfile}";
        dns_records_path = config.services.headscale.settings.dns.extra_records_path;
      };
      integration = {
        agent = {
          enabled = true;
          host_name = "headplane-agent";
          cache_ttl = 60000;
        };
        proc.enabled = true;
      };
      oidc = {
        enabled = true;
        issuer = config.web.sites.auth.url;
        use_end_session = true;
        post_logout_redirect_uri = "${config.services.headplane.settings.server.base_url}/admin/login?s=logout";
        client_id = "headscale";
        client_secret_path = config.age.secrets.${clientSecretFile}.path;
        use_pkce = true;
        disable_api_key_login = true;
        profile_picture_source = "oidc";
        scope = "openid email profile";
        subject_claims = [
          "open_id"
          "email"
        ];
        default_role = "member";
        role_claim = "headplane_role";
      };
    };
  };

  systemd.services.headplane-apikey = {
    requiredBy = [ headplaneSrv.name ];
    before = [ headplaneSrv.name ];
    requires = [ headscaleSrv.name ];
    after = [ headscaleSrv.name ];
    serviceConfig = {
      StateDirectory = apiStateDir;
      User = headplaneSrv.serviceConfig.User;
      Group = headplaneSrv.serviceConfig.Group;
      SupplementaryGroups = [ headscaleSrv.serviceConfig.Group ];
      Type = "oneshot";
    };
    unitConfig = {
      ConditionFileNotEmpty = "!/var/lib/${apiStateDir}/${apiKeyfile}";
    };
    path = [
      config.services.headscale.package
    ];
    script = "headscale apikeys create --expiration 50y > /var/lib/${apiStateDir}/${apiKeyfile}";
  };

  web.sites.headscale.locations."/admin".reverseProxy = config.web.ports.headplane;
  web.sites.headplane.locations = {
    "/".nginxConfig.return = "302 /admin";
    "/admin".reverseProxy = config.web.ports.headplane;
  };
}
