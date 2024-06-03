{ config, inputs, userSettings }:

let
  toRGBA = RGBhex: alpha:
    "rgba(${inputs.nix-colors.lib.conversions.hexToRGBString "," RGBhex}, ${builtins.toString alpha})";
in with config.colorScheme.palette; /* css */ ''
  * {
    border: none;
    border-radius: 0px;
    font-family: ${userSettings.default-font};
    font-size: 12px;
    font-style: normal;
    min-height: 0;
  }
  
  window#waybar {
    background: ${toRGBA base00 0.85};
    color: #${base06}
  }
  
  #workspaces {
  	background: ${toRGBA base01 0.85};
  	margin: 5px 5px 5px 5px;
    padding: 0px 5px 0px 5px;
  	border-radius: 16px;
    font-weight: normal;
    font-style: normal;
  }
  #workspaces button {
    padding: 0px 5px;
    border-radius: 16px;
    color: #928374;
  }
  
  #workspaces button.active {
    color: #${base06};
    background-color: transparent;
    border-radius: 16px;
  }
  
  #workspaces button:hover {
  	background-color: #${base0F};
  	color: black;
  	border-radius: 16px;
  }
  
  #clock, #battery, #pulseaudio, #network {
  	background: transparent;
  	padding: 5px 5px 5px 5px;
  	margin: 5px 5px 5px 5px;
    border-radius: 8px;
    border: solid 0px #f4d9e1;
  }
  
  #tray {
    background: ${toRGBA base01 0.85};
    margin: 5px 5px 5px 5px;
    border-radius: 16px;
    padding: 0px 5px;
  }
  
  #clock {
    color: #${base06};
    background-color: ${toRGBA base01 0.85};
    border-radius: 0px 0px 0px 24px;
    padding-left: 13px;
    padding-right: 15px;
    margin-right: 0px;
    margin-left: 10px;
    margin-top: 0px;
    margin-bottom: 0px;
    font-weight: bold;
  }
  
  #battery {
    background-color: ${toRGBA base01 0.85};
    border-radius: 16px;
    margin: 5px;
    margin-left: 5px;
    margin-right: 5px;
    padding: 0px 13px 0px 7px;
    font-weight: bold;
  }
  
  #battery.charging {
    color: #${base0B};
  }
  
  #battery.warning:not(.charging) {
    background-color: #${base08};
    border-radius: 5px 5px 5px 5px;
  }
  
  #backlight {
    color: #${base06};
    border-radius: 8px;
    margin-right: 5px;
  }
  
  #network {
    color: #${base06};
    border-radius: 8px;
    margin-right: 5px;
  }
  
  #pulseaudio {
    color: #${base06};
    border-radius: 8px;
    margin-left: 0px;
  }
  
  #pulseaudio.muted {
    background: transparent;
    color: #928374;
    border-radius: 8px;
    margin-left: 0px;
  }
  
  #custom-playerctl {
  	background: ${toRGBA base01 0.85};
  	padding-left: 15px;
    padding-right: 14px;
  	border-radius: 16px;
    margin-top: 5px;
    margin-bottom: 5px;
    margin-left: 0px;
    font-weight: normal;
    font-style: normal;
    font-size: 16px;
  }
  
  #custom-playerlabel {
    background: transparent;
    padding-left: 10px;
    padding-right: 15px;
    border-radius: 16px;
    margin-top: 5px;
    margin-bottom: 5px;
    font-weight: normal;
    font-style: normal;
  }
  
  #window {
    background: ${toRGBA base01 0.85};
    padding-left: 15px;
    padding-right: 15px;
    border-radius: 16px;
    margin-top: 5px;
    margin-bottom: 5px;
    font-weight: normal;
    font-style: normal;
  }
  
  #cpu {
    background-color: ${toRGBA base01 0.85};
    border-radius: 16px;
    margin: 5px;
    margin-left: 5px;
    margin-right: 5px;
    padding: 0px 10px 0px 10px;
    font-weight: bold;
  }
  #temperature {
    background-color: ${toRGBA base01 0.85};
    border-radius: 16px;
    margin: 5px;
    margin-left: 5px;
    margin-right: 5px;
    padding: 0px 10px 0px 10px;
    font-weight: bold;
  }
  #memory {
    background-color: ${toRGBA base01 0.85};
    border-radius: 16px;
    margin: 5px;
    margin-left: 5px;
    margin-right: 5px;
    padding: 0px 10px 0px 10px;
    font-weight: bold;
  }
''
