{ pkgs, config }:

let
  hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
  nm-connection-editor = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
  pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";
  playerctl = "${config.services.playerctld.package}/bin/playerctl";
  swaync-client = "${pkgs.swaynotificationcenter}/bin/swaync-client";
in /* json */ ''
{
  "layer": "top",
  "position": "top",
  "spacing": 4,
  "modules-left": ["hyprland/workspaces", "custom/playerctl", "custom/playerlabel" ],
  "modules-center": ["cpu", "memory", "temperature", "battery"],
  "modules-right": ["tray", "pulseaudio", "backlight", "network", "custom/notification", "clock"],
  "custom/power": {
    "format": "",
    "on-click": "rofi-powermenu"
  },
  "hyprland/workspaces": {
    "disable-scroll": true,
    "on-click": "activate",
    "format": "{icon}",
    "format-icons": {
      "urgent": "",
      "active": "",  
      "default": "󰧞"
    },
    "sort-by-number": true,
    "on-scroll-up": "${hyprctl} dispatch split-workspace w+1",
    "on-scroll-down": "${hyprctl} dispatch split-workspace w-1",
    "persistent-workspaces": {
      "*": 10
    }
  },
  "custom/playerctl": {
    "format": "{icon}",
    "return-type": "json",
    "max-length": 36,
    "exec": "${playerctl} metadata --format '{\"text\": \"{{markup_escape(title)}} - {{artist}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F",
    "on-click": "${playerctl} play-pause",
    "on-scroll-up": "${playerctl} previous",
    "on-scroll-down": "${playerctl} next",
    "format-icons": {
      "Playing": "<span foreground='#E5B9C6'>󰒮 󰏥 󰒭</span>",
      "Paused": "<span foreground='#928374'>󰒮 󰐌 󰒭</span>"
    }
  },
  "custom/playerlabel": {
    "format": "<span>{}</span>",
    "return-type": "json",
    "max-length": 48,
    "exec": "${playerctl} metadata --format '{\"text\": \"{{markup_escape(title)}} - {{artist}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F"                          
  },
  "custom/notification": {
    "tooltip": false,
    "format": "{icon}",
    "format-icons": {
      "notification": "<span foreground='red'><small><sup>⬤</sup></small></span>",
      "none": " ",
      "dnd-notification": "<span foreground='red'><small><sup>⬤</sup></small></span>",
      "dnd-none": " "
    },
    "return-type": "json",
    "exec-if": "which ${swaync-client}",
    "exec": "${swaync-client} -swb",
    "on-click": "sleep 0.1 && ${swaync-client} -t -sw",
    "on-click-right": "sleep 0.1 && ${swaync-client} -d -sw",
    "escape": true
  },
  "tray": {
    "spacing": 10,
    "reverse-direction": true,
    "show-passive-items": true
  },
  "clock": {
    "interval": 15,
    "format": " {:%H:%M %a %d.%m}",
    "tooltip-format": "<tt><small>{calendar}</small></tt>",
    "calendar": {
	  "mode"          : "year",
	  "mode-mon-col"  : 3,
	  "weeks-pos"     : "right",
	  "on-scroll"     : 1,
	  "on-click-right": "mode",
	  "format": {
	  	"months":     "<span color='#ffead3'><b>{}</b></span>",
	  	"days":       "<span color='#ecc6d9'><b>{}</b></span>",
	  	"weeks":      "<span color='#99ffdd'><b>W{}</b></span>",
	  	"weekdays":   "<span color='#ffcc66'><b>{}</b></span>",
	  	"today":      "<span color='#ff6699'><b><u>{}</u></b></span>"
	  }
	},
    "actions": {
	    "on-click-right": "mode",
	    "on-click-forward": "tz_up",
	  	"on-click-backward": "tz_down",
	  	"on-scroll-up": "shift_up",
	  	"on-scroll-down": "shift_down"
	  },     
    "on-click": "${pkgs.gnome.gnome-calendar}"
  },
  "memory": {
    "format": "󰍛 {}%",
    "format-alt": "󰍛 {used}/{total} GiB",
    "interval": 15
  },
  "cpu": {
    "format": "󰻠 {usage}%",
    "format-alt": "󰻠 {avg_frequency} GHz",
    "interval": 15
  },
  "temperature": {
    "thermal-zone": 2,
    "critical-threshold": 80,
    "format": "{temperatureC}°C {icon}",
    "format-icons": ["", "", ""],
    "interval": 15
  },
  "battery": {
    "interval": 15,
    "states": {
      "warning": 30,
      "critical": 15
    },
    "format": "{capacity}% {icon}",
    "format-icons": ["", "", "", "", ""],
    "max-length": 25,
    "format-charging": "{capacity}% {icon}"
  },
  "network": {
    "format-wifi": "  {essid}",
    "format-ethernet": "  {ifname}/{cidr}",
    "tooltip-format": "{ifname}: {ipaddr}/{cidr} via {gwaddr} ",
    "format-linked": "  {ifname} (No IP) ",
    "format-disconnected": "Disconnected ⚠",
    "on-click": "${nm-connection-editor}"
  },
  "pulseaudio": {
    "format": "{volume}% {icon} {format_source}",
    "format-bluetooth": "{volume}% {icon} {format_source}",
    "format-bluetooth-muted": " {icon} {format_source}",
    "format-muted": " {format_source}",
    "format-source": "{volume}% ",
    "format-source-muted": "",
    "format-icons": {
      "headphone": "",
      "hands-free": "",
      "headset": "",
      "phone": "",
      "portable": "",
      "car": "",
      "default": ["", "", ""]
    },
    "on-click": "${pavucontrol}"
  },
  "backlight": {
  	"device": "intel_backlight",
  	"format": "{percent}% {icon}",
  	"format-icons": ["", "", "", "", "", "", "", "", ""]
  }
}
  
''
