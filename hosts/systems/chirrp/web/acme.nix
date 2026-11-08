{
  config,
  lib,
  ...
}:

let
  cfg = config.security.acme;
in
{
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "acme@${config.web.primaryDomain}";
      dnsResolver = "1.1.1.1:53";

      dnsProvider = "netcup";
      environmentFile = config.age.secrets."acme-netcup-env".path;
    };
  };

  security.acme.certs = lib.mapAttrs' (
    _: v:
    lib.nameValuePair v.domain {
      domain = v.domain;
      extraDomainNames = v.extraDomains;
      webroot = lib.mkIf (cfg.defaults.dnsProvider == null) "/var/lib/acme/acme-challenge-${v.domain}";
      group = config.services.nginx.group;
    }
  ) (lib.filterAttrs (_: v: v.ssl && v.genCert) config.web.sites);

  services.restic.backups.acme = {
    initialize = true;
    paths = [ "/var/lib/acme/.lego/accounts" ];
    repository = "rclone:proton:/backup/${config.networking.hostName}/acme";
    rcloneOptions.protondrive-replace-existing-draft = true;
    passwordFile = config.age.secrets."restic-acme".path;
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
      "--keep-yearly 75"
    ];
    timerConfig = {
      OnCalendar = "01:30";
      Persistent = true;
    };
  };
}
