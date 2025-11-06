{ lib, ... }:

{
  options = {
    vars = lib.mkOption {
      default = {};
      type = lib.types.attrs;
    };
  };
}
