{ pkgs }:

pkgs.vimPlugins.base16-nvim.overrideAttrs (final: prev: {
  patches = (prev.patches or []) ++ [ ./colour-fix.patch ];
})
