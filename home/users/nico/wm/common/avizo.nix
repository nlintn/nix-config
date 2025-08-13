{ config, nix-colors, ... }:

let
  toRGBA = RGBhex: alpha:
    "rgba(${nix-colors.lib.conversions.hexToRGBString "," RGBhex},${builtins.toString alpha})";
in {
  services.avizo = {
    enable = true;
    settings.default = with config.colorScheme.palette; {
      time = 1.5;
      fade-in = 0.1;
      fade-out = 0.2;
      image-opacity = 0.9;
      border-color = toRGBA base02 0.9;
      background = toRGBA base00 0.9;
      bar-fg-color = "rgba(160, 160, 160, 0.9)";
    };
  };
}
