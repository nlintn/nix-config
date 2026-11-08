{
  ...
}:

{
  imports = [
    ./options.nix

    ./acme.nix
    ./dirs.nix
    ./nginx.nix
    ./services
    ./static
    ./tailscale.nix
    ./wg-tunnel.nix
  ];

  web = {
    primaryDomain = "nlintn.de";
    extraDomains = [
      "tn.nlintn.de"
    ];
    defaultRobotsTxtContent = ''
      User-agent: *
      Disallow: /
    '';
  };
}
