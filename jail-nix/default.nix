jail-nix:

final: prev:

let
  pkgs = final;
  lib = prev.lib;
  jail = import ./wrapper.nix jail-nix pkgs;
in
{
  inherit jail;
}
// (import ./overlay jail.combinators pkgs |> lib.mapAttrs (n: v: jail prev.${n} v))
