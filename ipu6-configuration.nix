{ config, inputs, lib, pkgs, modulesPath, ... }:

let
  ivsc-firmware = with pkgs;
    stdenv.mkDerivation rec {
      pname = "ivsc-firmware";
      version = "main";

      src = pkgs.fetchFromGitHub {
        owner = "intel";
        repo = "ivsc-firmware";
        rev = "10c214fea5560060d387fbd2fb8a1af329cb6232";
        sha256 = "sha256-kEoA0yeGXuuB+jlMIhNm+SBljH+Ru7zt3PzGb+EPBPw=";

      };

      installPhase = ''
        mkdir -p $out/lib/firmware/vsc/soc_a1_prod

        cp firmware/ivsc_pkg_ovti01a0_0.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_pkg_ovti01a0_0_a1_prod.bin
        cp firmware/ivsc_skucfg_ovti01a0_0_1.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_skucfg_ovti01a0_0_1_a1_prod.bin
        cp firmware/ivsc_fw.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_fw_a1_prod.bin
      '';
    };
in
{
  # Load also non-free firmwares in the kernel
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # for sake of ipu6-camera-bins
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # https://discourse.nixos.org/t/v4l2loopback-cannot-find-module/26301/5
    v4l-utils
  ];

  # Tracking Issue: Intel MIPI/IPU6 webcam-support
  # https://github.com/NixOS/nixpkgs/issues/225743#issuecomment-1849613797
  # Infrastructure Processing Unit
  hardware.ipu6 = {
    enable = true;
    platform = "ipu6ep";
  };

  hardware.firmware = [
    ivsc-firmware
    pkgs.ipu6-camera-bins
  ];

  # environment.etc.camera.source = "${ipu6-camera-hal}/share/defaults/etc/camera";
}
