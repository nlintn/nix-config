{ config }:

with config.colorScheme.palette; {
  primary = {
    background = "#${base00}";
    foreground = "#${base05}";
    dim_foreground = "#${base05}";
    bright_foreground = "#${base05}";
  };
  cursor = {
    text = "#${base00}";
    cursor = "#${base06}";
  };
  vi_mode_cursor = {
    text = "#${base00}";
    cursor = "#${base07}";
  };
  search.matches = {
    foreground = "#${base00}";
    background = "#${base04}";
  };
  search.focused_match = {
    foreground = "#${base00}";
    background = "#${base0B}";
  };
  footer_bar = {
    foreground = "#${base00}";
    background = "#${base04}";
  };
  hints.start = {
    foreground = "#${base00}";
    background = "#${base0A}";
  };
  hints.end = {
    foreground = "#${base00}";
    background = "#${base04}";
  };
  selection = {
    foreground = "#${base00}";
    background = "#${base06}";
  };
  normal = {
    black = "#${base03}";
    red = "#${base08}";
    green = "#${base0B}";
    yellow = "#${base0A}";
    blue = "#${base0D}";
    magenta = "#${base0E}";
    cyan = "#${base0C}";
    white = "#${base07}";
  };
  bright = {
    black = "#${base03}";
    red = "#${base08}";
    green = "#${base0B}";
    yellow = "#${base0A}";
    blue = "#${base0D}";
    magenta = "#${base0E}";
    cyan = "#${base0C}";
    white = "#${base07}";
  };
  dim = {
    black = "#${base03}";
    red = "#${base08}";
    green = "#${base0B}";
    yellow = "#${base0A}";
    blue = "#${base0D}";
    magenta = "#${base0E}";
    cyan = "#${base0C}";
    white = "#${base07}";
  };
  indexed_colors = [
    { index = 16; color = "#${base09}"; }
    { index = 17; color = "#${base0F}"; }
    { index = 18; color = "#${base01}"; }
    { index = 19; color = "#${base02}"; }
    { index = 20; color = "#${base04}"; }
    { index = 21; color = "#${base06}"; }
  ];
}
