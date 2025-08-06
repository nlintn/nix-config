{ ... } @ args:

{
  programs.bat = {
    enable = true;
    config = {
      theme = "base16";
      paging = "always";
    };
    themes = {
      "base16".src = import ./theme.nix args;
    };
  };
}
