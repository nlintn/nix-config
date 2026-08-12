{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.language = {
    address = "de_DE.UTF-8";
    base = "en_US.UTF-8";
    collate = "en_US.UTF-8";
    ctype = "C.UTF-8";
    measurement = "de_DE.UTF-8";
    messages = "en_US.UTF-8";
    monetary = "de_DE.UTF-8";
    name = "de_DE.UTF-8";
    numeric = "en_DK.UTF-8";
    paper = "de_DE.UTF-8";
    telephone = "de_DE.UTF-8";
    time = "en_IE.UTF-8";
  };

  i18n.glibcLocales = pkgs.glibcLocales.override {
    allLocales = false;
    locales = lib.attrValues config.home.language |> lib.unique |> lib.map (s: "${s}/UTF-8");
  };
}
