let
  nico = builtins.readFile ../assets/nico_id_ed25519.pub;

  meoww = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICUHE+IBj22wrYypVrpaEhbGQh376+/e4gtX7KnbCUO/";
in
{
  "meoww/nix-key-meoww.age".publicKeys = [
    nico
    meoww
  ];
}
