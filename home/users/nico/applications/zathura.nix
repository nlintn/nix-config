{
  config,
  lib-custom,
  pkgs,
  ...
}:

let
  inherit (lib-custom.conversions) hexAToRGBA;
in
{
  xdg.configFile."zathura/zathurarc".enable = false;
  programs.zathura = {
    enable = true;
    package = pkgs.jail pkgs.zathura (
      with pkgs.jail.combinators;
      [
        (readonly config.xdg.userDirs.documents)
        (readwrite config.xdg.userDirs.download)

        gui-enhanced
        open-urls-in-browser
        (desktop-portal "org.pwmt.zathura")
        (mount-home-file config.xdg.configFile."zathura/zathurarc")
        readonly-runtime-args
      ]
    );
    mappings = {
      "<Return>" = "navigate next";
      "<S-Return>" = "navigate previous";
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
      default-bg = hexAToRGBA base00 0.5 |> toString;

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
      index-active-bg = hexAToRGBA base0E 0.5 |> toString;

      render-loading-bg = hexAToRGBA base00 0.5 |> toString;
      render-loading-fg = "#${base05}";

      highlight-fg = "#${base05}";
      highlight-color = hexAToRGBA base09 0.5 |> toString;
      highlight-active-color = hexAToRGBA base08 0.5 |> toString;

      show-signature-information = true;
      signature-error-color = "#${base08}";
      signature-warning-color = "#${base09}";
      signature-success-color = "#${base0B}";
    };
  };
}
