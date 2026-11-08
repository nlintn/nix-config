{
  ...
}:

{
  networking.hostId = "c7902c26";

  age.secrets."zfs-zp1_chirrp-key".path = "/run/zfs-keys/zp1-chirrp.key";

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };
}
