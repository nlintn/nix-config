{ config, ... }:

{
  programs.kitty.settings = with config.colorscheme.palette; {
    foreground = "#${base05}";
    background = "#${base00}";
    selection_foreground = "#${base00}";
    selection_background = "#${base06}";

    cursor = "#${base06}";
    cursor_text_color = "#${base00}";

    url_color = "#${base06}";

    active_border_color = "#${base07}";
    inactive_border_color = "#${base04}";
    bell_border_color = "#${base0A}";

    wayland_titlebar_color = "#${base00}";

    active_tab_foreground = "#${base01}";
    active_tab_background = "#${base0E}";
    inactive_tab_foreground = "#${base05}";
    inactive_tab_background = "#${base01}";
    tab_bar_background = "#${base01}";

    mark1_foreground = "#${base00}";
    mark1_background = "#${base07}";
    mark2_foreground = "#${base00}";
    mark2_background = "#${base0E}";
    mark3_foreground = "#${base00}";
    mark3_background = "#${base0C}";

    color0 = "#${base03}";
    color8 = "#${base03}";

    color1 = "#${base08}";
    color9 = "#${base08}";

    color2 = "#${base0B}";
    color10 = "#${base0B}";

    color3 = "#${base0A}";
    color11 = "#${base0A}";

    color4 = "#${base0D}";
    color12 = "#${base0D}";

    color5 = "#${base0E}";
    color13 = "#${base0E}";

    color6 = "#${base0C}";
    color14 = "#${base0C}";

    color7 = "#${base07}";
    color15 = "#${base07}";
  };
}
