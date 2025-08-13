{ lib, lanzaboote, ... }:

{
  imports = [
    lanzaboote.nixosModules.lanzaboote
  ];

  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
  };
  boot.loader.systemd-boot.enable = lib.mkForce false;

}
