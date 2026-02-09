{ config, ... }:

{
  environment.systemPackages = [
    config.boot.loader.limine.secureBoot.sbctl
  ];

  boot.loader = {
    timeout = 1;
    limine = {
      enable = true;
      secureBoot.enable = true;
      enableEditor = true;
      panicOnChecksumMismatch = true;
      maxGenerations = 20;
      extraConfig = ''
        quiet: yes
      '';

      style = with config.colorScheme.palette; {
        wallpapers = [ ];
        wallpaperStyle = "centered";
        backdrop = "000000";
        graphicalTerminal = {
          font.scale = "1x1";
          background = "ff${base00}";
          brightBackground = "ff${base02}";
          foreground = "ff${base05}";
          brightForeground = "ff${base0E}";
          palette = builtins.concatStringsSep ";" [
            base01
            base08
            base0B
            base0A
            base0D
            base0E
            base0C
            base07
          ];
          brightPalette = builtins.concatStringsSep ";" [
            base03
            base08
            base0B
            base0A
            base0D
            base0E
            base0C
            base07
          ];
        };
        interface = {
          branding = config.networking.hostName;
          brandingColor = 5;
        };
      };
    };
  };
}
