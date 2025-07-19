{ disk ? "/dev/nvme1n1", ... }:

{
  disko.devices = {
    disk = {
      main = {
        device = disk;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              label = "boot";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                settings.allowDiscards = true;
                content = {
                  type = "lvm_pv";
                  vg = "pool";
                };
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%";
            # extraArgs = [ "--addtag root" ];
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [ "defaults" ];
            };
          };
          home = {
            size = "512G";
            # extraArgs = [ "--addtag home" ];
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/home";
            };
          };
          swap = {
            size = "16G";
            # extraArgs = [ "--addtag swap" ];
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };
        };
      };
    };
  };
}
