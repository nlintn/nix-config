{
  config,
  lib,
  pkgs,
  ...
}:

let
  keyfile = "crypto_key";
  cleanupScript = pkgs.writeShellApplication {
    name = "passless-boot_post_boot_cleanup";
    text = lib.readFile ./passless-boot_post_boot_cleanup.sh;
    runtimeInputs = [
      pkgs.cryptsetup
      pkgs.util-linux
    ];
    runtimeEnv = {
      cryptdevice = "/dev/disk/by-partlabel/disk-main-luks";
      keyfile = "/boot/${keyfile}";
    };
  };
  script = pkgs.writeShellApplication {
    name = "passless-boot";
    text = lib.readFile ./passless-boot.sh;
    runtimeInputs = [
      pkgs.cryptsetup
      cleanupScript
    ];
    runtimeEnv = {
      cryptdevice = "/dev/disk/by-partlabel/disk-main-luks";
      cryptkey_device = "/dev/disk/by-partlabel/boot";
      keyfile = "/boot/${keyfile}";
    };
  };
in
{
  boot.initrd =
    let
      bootMntLoc = "/mnt-boot";
    in
    {
      availableKernelModules = [
        "vfat"
        "nls_cp437"
        "nls_iso8859_1"
      ];
      systemd.mounts = [
        {
          where = bootMntLoc;
          what = config.disko.devices.disk.main.content.partitions.ESP.device;
          type = "vfat";
          wantedBy = [ "cryptsetup-pre.target" ];
          before = [ "cryptsetup-pre.target" ];
        }
      ];
      luks.devices.crypted = {
        keyFile = "${bootMntLoc}/${keyfile}";
        keyFileTimeout = 10;
      };
    };

  environment.systemPackages = [
    cleanupScript
    script
  ];

  systemd.services."passless-boot_post_boot_cleanup" = {
    description = "protect luks keyfile and reset default target on unencrypted /boot after passless boot";
    wantedBy = [ "default.target" ];
    script = lib.getExe cleanupScript;
    serviceConfig = {
      Type = "oneshot";
    };
  };
}
