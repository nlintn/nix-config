{
  assets,
  lib,
  ...
}:

{
  nix = {
    settings = {
      trusted-public-keys = [
        (lib.readFile assets."nix-key-meoww.pub")
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-old";
    };
  };
}
