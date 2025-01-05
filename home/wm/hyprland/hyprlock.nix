{ pkgs, config, userSettings, ... }:

{
  programs.hyprlock = with config.colorScheme.palette; {
    enable = true;
    
    settings = {
      general = {
        no_fade_in = true;
        no_fade_out = true;
        grace = 0;
        disable_loading_bar = true;
        hide_cursor = true;
        ignore_empty_input = true;
        pam_module = "su";
      };

      background = [
        {
          path = builtins.path { name = "hyprlock-img"; path = userSettings.lockscreen; };
        }
      ];
      
      input-field = [
        {
          size = "250, 60";
          outline_thickness = 2;
          dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = true;
          outer_color = "rgba(0, 0, 0, 0)";
          inner_color = "rgba(0, 0, 0, 0.5)";
          font_color = "rgb(200, 200, 200)";
          fade_on_empty = false;
          placeholder_text = "<i><span font='${userSettings.default-font} 12'>UwU</span></i>";
          hide_input = false;
          position = "0, -140";
          halign = "center";
          valign = "center";
          check_color = "rgb(${base09})";
          fail_color = "rgb(${base08})";
          fail_text = "<i><span font='${userSettings.default-font} 12'>$FAIL</span></i>";
        }
      ];
      
      label = [
        {
          text = "cmd[update:1000] ${pkgs.coreutils}/bin/date +%H:%M:%S";
          color = "rgba(${base05}cc)";
          font_size = 150;
          font_family = "${userSettings.default-font} Mono ExtraBold";
          position = "0, 80";
          halign = "center";
          valign = "center";
        }  
        {
          text = "hi there, $USER :3";
          color = "rgba(${base05}cc)";
          font_size = 20;
          font_family = "${userSettings.default-font} Mono";
          position = "0, -80";
          halign = "center";
          valign = "center";
        }
        {
          text = "cmd[update:1000] ${config.services.playerctld.package}/bin/playerctl metadata --format '{{title}} | {{artist}}'";
          color = "rgba(${base05}cc)";
          font_size = 20;
          font_family = "${userSettings.default-font}";
          position = "0, 30";
          halign = "center";
          valign = "bottom";
        }
      ];
    };
  };
}
