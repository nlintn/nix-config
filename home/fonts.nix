{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-emoji
    noto-fonts-extra
    noto-fonts-cjk-sans
    font-awesome
    montserrat
  ];
}
