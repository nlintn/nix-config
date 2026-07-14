{
  config,
  ...
}:

with config.colorScheme.palette;
{
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
  palette-generate = true;

  background = "#${base00}";
  cursor-color = "#${base06}";
  cursor-text = "#${base01}";
  foreground = "#${base05}";
  search-background = "#${base09}";
  search-foreground = "#${base01}";
  search-selected-background = "#${base08}";
  search-selected-foreground = "#${base01}";
  selection-background = "#${base06}";
  selection-foreground = "#${base01}";
}
