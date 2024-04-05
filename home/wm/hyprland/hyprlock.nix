{ pkgs, config, inputs, userSettings, ... }:

{
  imports = [
    inputs.hyprlock.homeManagerModules.hyprlock
  ];

  programs.hyprlock = with config.colorScheme.palette; {
    enable = true;
    
    general = {
      no_fade_in = false;
      grace = 0;
      disable_loading_bar = true;
    };

    backgrounds = [
      {
        path = userSettings.lockscreen;
        blur_passes = 3;
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      }
    ];
    
    input-fields = [
      {
        size = { width = 250; height = 60; };
        outline_thickness = 2;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        outer_color = "rgba(0, 0, 0, 0)";
        inner_color = "rgba(0, 0, 0, 0.5)";
        font_color = "rgb(200, 200, 200)";
        fade_on_empty = false;
        placeholder_text = "<i><span font='JetBrainsMono Nerd Font Mono 12'>Input Password...</span></i>";
        hide_input = false;
        position = { x = 0; y = -120; };
        halign = "center";
        valign = "center";
      }
    ];
    
    labels = [
      {
        text = "cmd[update:1000] ${pkgs.coreutils}/bin/date +%H:%M:%S";
        color = "rgba(${base05}cc)";
        font_size = 130;
        font_family = "JetBrainsMono Nerd Font Mono ExtraBold";
        position = { x = 0; y = 60; };
        halign = "center";
        valign = "center";
      }  
      {
        text = "hi there, $USER :)";
        color = "rgba(${base05}cc)";
        font_size = 20;
        font_family = "JetBrains Mono Nerd Font Mono";
        position = { x = 0; y = -40; };
        halign = "center";
        valign = "center";
      }
      {
        text = "cmd[update:1000] ${config.services.playerctld.package}/bin/playerctl metadata --format '{{title}} - {{artist}}'";
        color = "rgba(${base05}cc)";
        font_size = 20;
        font_family = "JetBrainsMono Nerd Font";
        position = { x = 0; y = 30; };
        halign = "center";
        valign = "bottom";
      }
    ];
  };
}
