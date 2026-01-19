{ config, lib, pkgs, hmSubmodules, ... }:

{
  users.users.nico = {
    isNormalUser = true;
    description = "Nico Lintner";
    extraGroups = [
      "wheel" "seat" "video" "render"
      (lib.mkIf config.networking.networkmanager.enable "networkmanager")
      (lib.mkIf config.programs.wireshark.enable "wireshark")
      (lib.mkIf config.hardware.i2c.enable "i2c")
    ];
    shell = lib.mkIf config.programs.zsh.enable pkgs.zsh;
  };
  imports = [ hmSubmodules.nico ];
}
