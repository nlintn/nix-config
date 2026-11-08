{
  assets,
  ...
}:

{
  boot = {
    initrd = {
      availableKernelModules = [
        "e1000"
        "virtio_net"
      ];
      systemd.users.root.shell = "/usr/bin/systemd-tty-ask-password-agent";
      network = {
        enable = true;
        flushBeforeStage2 = true;
        ssh = {
          enable = true;
          port = 2222;
          authorizedKeys = [
            (builtins.readFile assets."homelab_id_ed25519.pub")
          ];
          hostKeys = [
            "/etc/initrd-secrets/ssh_host_rsa_key"
            "/etc/initrd-secrets/ssh_host_ed25519_key"
          ];
        };
      };
    };
  };
}
