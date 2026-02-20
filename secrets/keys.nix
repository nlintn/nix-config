rec {
  hosts = {
    chirrp = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKbvfAP54Tsk91Hhhxa1PtYkcN0M6Fi+LGHMaOj4VHS9";
    meoww = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICUHE+IBj22wrYypVrpaEhbGQh376+/e4gtX7KnbCUO/";
    whirr = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN4n/tIWKs8Vz2JNk+52XkFKGxp3RGxdb29AjGAgkk/k";
  };
  users = {
    nico = builtins.readFile ../assets/nico_id_ed25519.pub;
  };
  admin = [
    users.nico
  ];
}
