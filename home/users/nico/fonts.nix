{
  pkgs,
  userSettings,
  ...
}:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    (userSettings.default-font.getPackage pkgs)
    font-awesome
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    raleway
  ];
}
