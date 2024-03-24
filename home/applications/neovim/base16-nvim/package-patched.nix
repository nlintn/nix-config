{ pkgs }:

/* let package_patched = (
  pkgs.fetchFromGitHub {
    owner = "RRethy";
    repo = "base16-nvim";
    rev = "b3e9ec6a82c05b562cd71f40fe8964438a9ba64a";
    hash = "sha256-l0BO2boIy6mwK8ISWS3D68f8egqHYwsGSAnzjbB5aOE=";
  }).overrideAttrs (final: prev: {
    patches = (prev.patches or []) ++ [ ./colour-fix.patch ];
  }); 
in pkgs.vimUtils.buildVimPlugin {
  name = "base16-nvim";
  src = package_patched;
} */
pkgs.vimPlugins.base16-nvim.overrideAttrs (final: prev: {
  patches = (prev.patches or []) ++ [ ./colour-fix.patch ];
}) 
