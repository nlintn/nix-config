{
  config,
  lib,
  ...
}:

{
  web.ports.librespeed = null;

  services.librespeed = {
    enable = true;
    settings = {
      listen_port = config.web.ports.librespeed;
    };
    domain = config.web.sites.speed.domain;
    frontend = {
      enable = true;
      contactEmail = "speed@nlintn.de";
      useNginx = true;
      servers = lib.mkForce (
        config.web.sites.speed.allDomains
        |> lib.map (n: {
          name = n;
          server = "//${n}";
        })
      );
    };
  };

  web.sites.speed = {
    restrictAccess = {
      auth.enable = true;
      origin.enable = true;
    };
  };
}
