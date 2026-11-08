{
  assets,
  ...
}:

{
  users.users = {
    nico = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keyFiles = [
        assets."homelab_id_ed25519.pub"
      ];
    };
  };
}
