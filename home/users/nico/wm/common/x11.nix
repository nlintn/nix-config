{ lib, ... }:

{
  vars = {
    x11Support = true;
    waylandSupport = lib.mkDefault false;
  };
}
