{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-media-tags-plugin
      thunar-volman
    ];
  };
  xdg.configFile."Thunar/uca.xml" = {
    force = true;
    text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <actions>
      <action>
        <icon></icon>
        <name>Open Terminal Here</name>
        <submenu></submenu>
        <command>${lib.getExe config.xdg.terminal-exec.package |> lib.escapeXML} --dir=%f</command>
        <description></description>
        <range></range>
        <patterns>*</patterns>
        <directories/>
      </action>
      </actions>
    '';
  };
  xfconf.settings.thunar = {
    "last-location-bar" = "ThunarLocationButtons";
    "last-side-pane" = "THUNAR_SIDEPANE_TYPE_TREE";
    "misc-date-style" = "THUNAR_DATE_STYLE_YYYYMMDD";
    "misc-expandable-folders" = true;
    "misc-full-path-in-tab-title" = true;
    "misc-show-delete-action" = true;
    "misc-single-click" = false;
    "misc-symbolic-icons-in-sidepane" = false;
    "misc-thumbnail-draw-frames" = false;
    "misc-transfer-verify-file" = "THUNAR_VERIFY_FILE_MODE_ALWAYS";
    "misc-use-csd" = false;
  };
}
