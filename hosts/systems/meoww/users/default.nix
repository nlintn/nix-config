{ config, lib, pkgs, ... }:

{
  users.users.nico = {
    isNormalUser = true;
    description = "Nico Lintner";
    extraGroups = [
      "wheel"
      (lib.mkIf config.networking.networkmanager.enable "networkmanager")
      (lib.mkIf config.virtualisation.docker.enable "docker")
      (lib.mkIf config.programs.wireshark.enable "wireshark")
      (lib.mkIf config.hardware.i2c.enable "i2c")
    ];
    shell = lib.mkIf config.programs.zsh.enable pkgs.zsh;
  };
  imports = [
    (import ../../../../home/submodule.nix [ "nico" ])
  ];
}
