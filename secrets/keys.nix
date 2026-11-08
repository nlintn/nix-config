{
  hosts = {
    chirrp = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKbvfAP54Tsk91Hhhxa1PtYkcN0M6Fi+LGHMaOj4VHS9";
    meoww = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICUHE+IBj22wrYypVrpaEhbGQh376+/e4gtX7KnbCUO/";
    whirr = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAwXVRJ3RDTGeHyM9O7GPjPsGLHcmd6VI3F/E0tfc/Xt";
  };
  users = {
    nico = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILsvslWjOVn6FpOkjTNuf2hXDxYuFtiooDbFuQfd1a+Y";
  };
  admin = [
    (builtins.readFile ../assets/nico_id_ed25519.pub)
  ];
}
