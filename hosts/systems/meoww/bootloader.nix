{ lib, lanzaboote, ... }:

{
  imports = [
    lanzaboote.nixosModules.lanzaboote
  ];

  boot = {
    loader.efi.canTouchEfiVariables = true;
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    loader.systemd-boot.enable = lib.mkForce false;
  };

}
