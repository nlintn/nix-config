{ lib, pkgs, ... }@args:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    policies = {
      "3rdparty".Extensions = import ./extensionSettings.nix args;
    };
    profiles =
      let
        profiles = {
          test = { };
          default = import ./profiles/default args;
        };
      in
      (profiles |> lib.filterAttrs (_: v: v.isDefault or false) |> lib.mapAttrs (_: v: v // { id = 0; }))
      // (
        profiles
        |> lib.filterAttrs (_: v: !v.isDefault or false)
        |> lib.attrsToList
        |> lib.imap1 (
          i:
          { name, value }:
          {
            inherit name;
            value = value // {
              id = i;
            };
          }
        )
        |> builtins.listToAttrs
      );
  };
}
