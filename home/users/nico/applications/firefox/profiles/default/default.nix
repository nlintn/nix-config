{
  ...
}@args:

{
  isDefault = true;
  search = {
    default = "ddg";
    privateDefault = "ddg";
    force = true;
  };
  storeId = "f66680ba";

  extensions = import ./extensions.nix args;

  settings = import ./config.nix args;

  userChrome = import ./userChrome.nix args;

  userContent = import ./userContent.nix args;
}
