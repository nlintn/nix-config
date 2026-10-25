{
  config,
  lib-custom,
  pkgs,
  ...
}:

let
  inherit (lib-custom.conversions) hexAToRGBA;
in
{
  services.avizo = {
    enable = true;
    package = pkgs.avizo.overrideAttrs (p: {
      patchPhase =
        /* sh */ ''
          sed -i 's/#000000/#${config.colorScheme.palette.base05}/g' data/images/*.svg
          sed -i 's/\.png/.svg/g' {"avizo.gresource.xml","src/avizo_service.vala"}
        ''
        + p.patchPhase or "";
    });
    settings.default = with config.colorScheme.palette; {
      time = 1.5;
      fade-in = 0.1;
      fade-out = 0.2;
      image-opacity = 0.9;
      border-color = hexAToRGBA base03 0.8 |> toString;
      background = hexAToRGBA base00 0.5 |> toString;
      bar-fg-color = hexAToRGBA base05 0.9 |> toString;
      bar-bg-color = hexAToRGBA base01 0.9 |> toString;
    };
  };
}
