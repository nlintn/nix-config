{ config, inputs, userSettings }:

let
  toRGBA = RGBhex: alpha:
    "rgba(${inputs.nix-colors.lib.conversions.hexToRGBString "," RGBhex}, ${builtins.toString alpha})";
in with config.colorScheme.palette; /* css */ ''
  @define-color white #${base05};
  @define-color red #${base08};
  @define-color green #${base0B};
  @define-color teal #${base0C};
  @define-color orange #${base09};
  @define-color magenta #${base0E};
  @define-color flamingo #${base0F};
  @define-color bg #${base00};
  @define-color bg2 #${base01};
  
  * {
    border: none;
    border-radius: 0;
    min-height: 0;
    margin: 0;
    padding: 0;
    box-shadow: none;
    text-shadow: none;
    icon-shadow: none;
  }
  
  #waybar {
    color: @white;
    font-family: JetBrainsMono Nerd Font;
    font-size: 9pt;
    background: @bg;
  }
  
  #workspaces {
    padding-right: 8pt;
  }
  
  #memory,
  #cpu,
  #temperature,
  #battery,
  #window,
  #tray,
  #pulseaudio,
  #backlight,
  #network,
  #clock {
    padding-left: 8pt;
    padding-right: 8pt;
  }
  
  #memory.warning,
  #cpu.warning,
  #temperature.warning {
    color: @orange;
  }
  
  #battery.warning.discharging {
    color: @red;
  }
  #battery.charging {
    color: @green;
  }
  
  #workspaces button {
    padding-left: 0pt;
    padding-right: 0pt;
    color: @magenta;
    background: @bg2;
  }
  
  #workspaces button.empty {
    color: @white;
  }
  #workspaces button.visible {
    color: @bg2;
    background: @magenta;
  }
  #workspaces button.visible:hover {
    color: @bg2;
  }
  #workspaces button.focused {
    color: @bg2;
    background: @magenta;
  }
  #workspaces button.urgent {
    color: @red;
  }
  #workspaces button:hover {
    color: @flamingo;
  }
  
  #memory,
  #cpu,
  #temperature,
  #battery {
    color: @white;
    background: @bg;
  }
  
  #tray,
  #pulseaudio,
  #network,
  #backlight {
    color: @white;
    background: @bg;
  }
  
  #clock,
  #custom-notification {
    color: @white;
    background: @bg2;
  }
''
