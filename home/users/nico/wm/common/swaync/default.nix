{ ... } @ args:

{
  services.swaync = {
    enable = true;
    style = import ./theme.nix args;
    settings = {
      cssPriority = "user";
    };
  };
}
