{ config, lib, pkgs, ... }:

{
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-media-tags-plugin ];
  };
  xdg.configFile."Thunar/uca.xml" = {
    force = true;
    text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <actions>
      <action>
        <name>Open Terminal Here</name>
        <command>${lib.getExe config.xdg.terminal-exec.package}</command>
        <patterns>*</patterns>
        <directories/>
      </action>
      </actions>
    '';
  };
}
