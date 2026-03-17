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
        <name>Open Terminal Here</name>
        <command>${lib.getExe config.xdg.terminal-exec.package |> lib.escapeXML}</command>
        <patterns>*</patterns>
        <directories/>
      </action>
      </actions>
    '';
  };
}
