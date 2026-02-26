{
  config,
  lib,
  nix-colors,
  ...
}:

let
  toRGBA =
    RGBhex: alpha:
    "rgba(${nix-colors.lib.conversions.hexToRGBString "," RGBhex},${lib.toString alpha})";
in
{
  programs.zathura = {
    enable = true;
    mappings = {
      "<Return>" = "navigate next";
      "<S-Return>" = "navigate previous";

      "[index] <Left>" = "zoom collapse";
      "[index] <Right>" = "zoom expand";
    };
    options = with config.colorScheme.palette; {
      guioptions = "cs";
      selection-clipboard = "clipboard";
      statusbar-home-tilde = true;
      statusbar-page-percent = true;
      vertical-center = true;
      window-title-home-tilde = true;
      show-directories = true;
      show-hidden = true;

      default-fg = "#${base05}";
      default-bg = toRGBA base00 0.5;

      completion-bg = "#${base02}";
      completion-fg = "#${base05}";
      completion-highlight-bg = "#${base0E}";
      completion-highlight-fg = "#${base00}";
      completion-group-bg = "#${base01}";
      completion-group-fg = "#${base05}";

      statusbar-fg = "#${base05}";
      statusbar-bg = "#${base01}";
      inputbar-fg = "#${base05}";
      inputbar-bg = "#${base00}";

      notification-bg = "#${base00}";
      notification-fg = "#${base05}";
      notification-error-bg = "#${base00}";
      notification-error-fg = "#${base08}";
      notification-warning-bg = "#${base00}";
      notification-warning-fg = "#${base0A}";

      recolor = false;
      recolor-lightcolor = "#${base00}";
      recolor-darkcolor = "#${base05}";

      index-fg = "#${base05}";
      index-bg = "#${base00}";
      index-active-fg = "#${base05}";
      index-active-bg = toRGBA base0E 0.5;

      render-loading-bg = toRGBA base00 0.5;
      render-loading-fg = "#${base05}";

      highlight-fg = "#${base05}";
      highlight-color = toRGBA base09 0.5;
      highlight-active-color = toRGBA base08 0.5;

      show-signature-information = true;
      signature-error-color = "#${base08}";
      signature-warning-color = "#${base09}";
      signature-success-color = "#${base0B}";
    };
  };
}
