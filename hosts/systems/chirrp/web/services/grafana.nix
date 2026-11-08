{
  config,
  ...
}:

let
  clientSecretFile = "grafana-client_secret";
  secretKeyFile = "grafana-secret_key";

  authUrl = config.web.sites.auth.url;
in
{
  web.uds.grafana = { };

  age.secrets.${clientSecretFile}.owner = config.systemd.services.grafana.serviceConfig.User;
  age.secrets.${secretKeyFile}.owner = config.systemd.services.grafana.serviceConfig.User;

  services.grafana = {
    enable = true;
    settings = {
      server = {
        protocol = "socket";
        socket = config.web.uds.grafana.path;
        socket_mode = "0660";
        domain = config.web.sites.grafana.domain;
        root_url = config.web.sites.grafana.url;
      };
      security = {
        disable_initial_admin_creation = true;

        secret_key = "$__file{${config.age.secrets.${secretKeyFile}.path}}";
        cookie_secure = true;
        cookie_samesite = "lax";

        disable_gravatar = true;
      };
      analytics = {
        check_for_plugin_updates = false;
        check_for_updates = false;
        feedback_links_enabled = false;
        reporting_enabled = false;
      };
      "auth.generic_oauth" = {
        enabled = true;
        name = "PocketID";
        client_id = "grafana";
        client_secret = "$__file{${config.age.secrets.${clientSecretFile}.path}}";
        auth_url = "${authUrl}/authorize";
        token_url = "${authUrl}/api/oidc/token";
        api_url = "${authUrl}/api/oidc/userinfo";
        scopes = "openid profile email groups";
        email_attribute_name = "email:primary";
        role_attribute_path = "grafana_role";
        allow_sign_up = true;
        auto_login = true;
        allow_assign_grafana_admin = true;
        groups_attribute_path = "groups";
        allowed_groups = "admin users";
        use_pkce = true;
        use_refresh_token = true;
        validate_id_token = true;
        jwk_set_url = "${authUrl}/.well-known/jwks.json";
        signout_redirect_url = "${authUrl}/api/oidc/end-session";
      };
      metrics.enabled = true;
    };
    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
          isDefault = true;
          editable = false;
        }
      ];
    };
  };

  web.sites.grafana = {
    name = "metrics";
    aliases = [ "grafana" ];
    reverseProxy = config.web.uds.grafana.path;
    locations = {
      "/api/live/".nginxConfig.proxyWebsockets = true;
      "= /metrics".localhostOnly = true;
    };
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "grafana";
      scheme = "https";
      static_configs = [
        {
          targets = [ config.web.sites.grafana.domain ];
          labels.instance = config.networking.hostName;
        }
      ];
    }
  ];
}
