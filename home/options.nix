{ lib, ... }:

{
  options = {
    vars = lib.mkOption {
      default = {};
      apply = builtins.mapAttrs (n: v: if v ? content then v.content else v);
      type = lib.types.attrs;
    };
  };
}
