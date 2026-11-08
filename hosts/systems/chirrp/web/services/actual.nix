{
  config,
  ...
}:

{
  web.ports.actual = null;

  services.actual = {
    enable = true;
    settings = {
      hostname = "127.0.0.1";
      port = config.web.ports.actual;
      trustedProxies = [ "127.0.0.1" ];

      loginMethod = "openid";
      allowedLoginMethods = [ "openid" ];
      openId = {
        discoveryURL = "${config.web.sites.auth.url}/.well-known/openid-configuration";
        client_id = "actual";
        server_hostname = config.web.sites.actual.url;
        authMethod = "openid";
      };
    };
  };
  systemd.services.actual = {
    serviceConfig.EnvironmentFile = [
      config.age.secrets."actual-client_secret".path
    ];
  };

  web.sites.actual.reverseProxy = config.web.ports.actual;
}
