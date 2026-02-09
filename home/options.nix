{ lib, ... }:

{
  options = {
    vars = lib.mkOption {
      default = { };
      apply =
        let
          f = builtins.mapAttrs (
            n: v:
            let
              val = if v ? _type && v._type == "override" && v ? content then v.content else v;
            in
            if lib.isAttrs val then f val else val
          );
        in
        f;
      type = lib.types.attrs;
    };
  };
}
