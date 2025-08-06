{ config, pkgs, userSettings, ... }:

{
  home.sessionVariables = {
    __LOCK_CMD = "${config.programs.hyprlock.package}/bin/hyprlock";
    __UNLOCK_CMD =  "${pkgs.procps}/bin/pkill -SIGUSR1 hyprlock";
  };
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        grace = 0;
        hide_cursor = true;
        ignore_empty_input = true;
        immediate_render = true;
      };

      animation = [ "fade,0" ];

      auth = {
        "pam:module" = "su";
      };

      background = [
        {
          path = userSettings.lockscreen;
        }
      ];

      input-field = with config.colorScheme.palette; [
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
          placeholder_text = "<i><span font='${userSettings.default-font.name} 12'>UwU</span></i>";
          hide_input = false;
          position = "0, -140";
          halign = "center";
          valign = "center";
          check_color = "rgb(${base09})";
          fail_color = "rgb(${base08})";
          fail_text = "<i><span font='${userSettings.default-font.name} 12'>$FAIL</span></i>";
        }
      ];

      label = with config.colorScheme.palette; [
        {
          text = "cmd[update:1000] ${pkgs.coreutils}/bin/date +%H:%M:%S";
          color = "rgba(${base05}cc)";
          font_size = 150;
          font_family = "${userSettings.default-font.name} Mono ExtraBold";
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
        {
          text = "hi there, $USER :3";
          color = "rgba(${base05}cc)";
          font_size = 20;
          font_family = "${userSettings.default-font.name} Mono";
          position = "0, -80";
          halign = "center";
          valign = "center";
        }
        {
          text = "cmd[update:1000] ${config.services.playerctld.package}/bin/playerctl metadata --format '{{title}} | {{artist}}'";
          color = "rgba(${base05}cc)";
          font_size = 20;
          font_family = "${userSettings.default-font.name}";
          position = "0, 30";
          halign = "center";
          valign = "bottom";
        }
      ];
    };
  };
}
