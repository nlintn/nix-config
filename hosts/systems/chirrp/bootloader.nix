{
  config,
  ...
}:

{
  environment.systemPackages = [
    config.boot.loader.limine.secureBoot.sbctl
  ];

  boot.loader = {
    timeout = 1;
    limine = {
      enable = true;
      secureBoot = {
        enable = true;
        autoGenerateKeys = true;
      };
      enableEditor = false;
      panicOnChecksumMismatch = true;
      maxGenerations = 20;
    };
  };
}
