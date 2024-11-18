{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    noto-fonts
    noto-fonts-emoji
    noto-fonts-extra
    noto-fonts-cjk-sans
    font-awesome
    montserrat
  ];
}
