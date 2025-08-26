{ config, pkgs, nix-colors, ... }:

let
  toRGBA = RGBhex: alpha:
    "rgba(${nix-colors.lib.conversions.hexToRGBString "," RGBhex},${builtins.toString alpha})";
in {
  services.avizo = {
    enable = true;
    package = pkgs.avizo.overrideDerivation (p: {
      patchPhase = /* sh */ ''
        sed -i 's/#000000/#${config.colorScheme.palette.base05}/g' data/images/*.svg
        sed -i 's/\.png/.svg/g' {"avizo.gresource.xml","src/avizo_service.vala"}
      '' + p.patchPhase or "";
    });
    settings.default = with config.colorScheme.palette; {
      time = 1.5;
      fade-in = 0.1;
      fade-out = 0.2;
      image-opacity = 0.9;
      border-color = toRGBA base02 0.9;
      background = toRGBA base00 0.9;
      bar-fg-color = toRGBA base05 0.9;
      bar-bg-color = toRGBA base01 0.9;
    };
  };
}
