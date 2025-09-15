{ pkgs, userSettings, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    userSettings.default-font.package
    font-awesome
    noto-fonts
    noto-fonts-emoji
    noto-fonts-extra
    noto-fonts-cjk-sans
    raleway
  ];
}
