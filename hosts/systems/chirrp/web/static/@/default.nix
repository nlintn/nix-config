{
  config,
  lib,
  ...
}:

{
  web.sites."@" = {
    domain = config.web.primaryDomain;
    extraDomains = [ ];
    genMagicDnsEntry = false;
    robotsTxt.enable = false;
    nginxConfig = {
      default = true;
      root = lib.cleanSource ./source;
    };
  };
  security.acme.certs.${config.web.sites."@".domain}.extraDomainNames = [
    "*.${config.web.sites."@".domain}"
  ];
}
