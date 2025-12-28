{ agenix, nix-colors, ... }:

{
  imports = [
    agenix.nixosModules.default
    nix-colors.homeManagerModules.default
  ];
}
