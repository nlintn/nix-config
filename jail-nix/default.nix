jail-nix:

final: prev:

let
  pkgs = final;
  lib = prev.lib;
  jail = import ./wrapper.nix jail-nix pkgs;
in
(import ./overlay pkgs jail.combinators |> lib.mapAttrs (n: v: jail prev.${n} v))
// {
  inherit jail;
}
