{
  config,
  lib,
  ...
}:

{
  vars.shareGroup = "www-share";
  users.groups.${config.vars.shareGroup} = {
    gid = 985;
  };

  vars.shareDir = "/media/share";

  fileSystems.${config.vars.shareDir} = {
    device = "zp1-chirrp/media/share";
    fsType = "zfs";
  };

  systemd.tmpfiles.rules = [
    "d ${lib.escapeShellArg config.vars.shareDir} 7770 filebrowser ${lib.escapeShellArg config.vars.shareGroup} -"
  ];

  systemd.services.nginx.serviceConfig.SupplementaryGroups = [ config.vars.shareGroup ];
  web.sites.files = {
    nginxConfig = {
      root = config.vars.shareDir;
      extraConfig = ''
        autoindex on;
        index FEcqc0DfriqZZWZdy3D5RK6HPt3j9DsgND2QP6TweUrx7Y1Z4bWt6mIllu3x6SHb;
        try_files $uri $uri/ =404;
      '';
    };
    restrictAccess = {
      auth.enable = true;
      origin.enable = true;
    };
  };
}
