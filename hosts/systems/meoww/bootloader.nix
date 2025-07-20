{ lib, inputs, ... }:

{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  boot = {
    loader.efi.canTouchEfiVariables = false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    loader.systemd-boot.enable = lib.mkForce false;
  };

}
