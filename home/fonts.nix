{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    noto-fonts-extra
    noto-fonts-cjk
    (nerdfonts.override { fonts = [ "CascadiaMono" "JetBrainsMono" ]; })
    font-awesome
  ];
}