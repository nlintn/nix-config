{ config, ... }:

with config.colorScheme.palette;
{
  background = "#${base00}";
  cursor-color = "#${base06}";
  foreground = "#${base05}";
  palette = [
    "0=#${base01}"
    "8=#${base03}"

    "1=#${base08}"
    "9=#${base08}"

    "2=#${base0B}"
    "10=#${base0B}"

    "3=#${base0A}"
    "11=#${base0A}"

    "4=#${base0D}"
    "12=#${base0D}"

    "5=#${base0E}"
    "13=#${base0E}"

    "6=#${base0C}"
    "14=#${base0C}"

    "7=#${base07}"
    "15=#${base07}"
  ];
  selection-background = "#${base06}";
  selection-foreground = "#${base01}";
}
