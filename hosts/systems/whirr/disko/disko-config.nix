{
  # disk ? null,
  ...
}:

{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/vda";
        type = "disk";
        imageSize = "10G";
        imageName = "image-whirr";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              type = "EF02";
              size = "1M";
            };
            ESP = {
              size = "512M";
              type = "EF00";
              label = "boot";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "umask=0077"
                  "noatime"
                ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "luks";
                passwordFile = "/tmp/luks-passwd";
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
          swap = {
            size = "2G";
            content = {
              type = "swap";
              discardPolicy = "both";
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [
                "defaults"
                "x-systemd.device-timeout=infinity"
                "noatime"
              ];
            };
          };
        };
      };
    };
  };
}
