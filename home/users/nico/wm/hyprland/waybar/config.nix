{
  config,
  formats,
  lib,
  pwvucontrol,
  ...
}:

let
  inherit (config.vars) launchPrefix;

  conctl =
    launchPrefix + lib.getExe' config.services.network-manager-applet.package "nm-connection-editor";
  volctl = launchPrefix + lib.getExe pwvucontrol;
  swaync-client-raw = lib.getExe' config.services.swaync.package "swaync-client";
  swaync-client = launchPrefix + swaync-client-raw;
in
(formats.json { }).generate "waybar-config" (
  with config.colorScheme.palette;
  {
    layer = "top";
    position = "bottom";

    modules-left = [
      "hyprland/workspaces"
      "idle_inhibitor"
      "memory"
      "custom/delimiter1"
      "cpu"
      "custom/delimiter1"
      "temperature"
      "custom/delimiter1"
      "battery"
    ];

    modules-center = [
      "network"
    ];

    modules-right = [
      "tray"
      "custom/delimiter1"
      "pulseaudio"
      "custom/delimiter1"
      "backlight"
      "custom/delimiter2"
      "custom/notification"
      "clock"
    ];

    "custom/delimiter1" = {
      format = "│";
      tooltip = false;
    };
    "custom/delimiter2" = {
      format = " ";
      tooltip = false;
    };

    "hyprland/workspaces" = {
      disable-scroll = true;
      on-click = "activate";
      sort-by-number = true;
      spacing = 0;
    };

    idle_inhibitor = {
      format = "{icon}";
      format-icons = {
        activated = "";
        deactivated = "";
      };
    };

    memory = {
      interval = 15;
      format = "Mem {percentage:3}%";
      states = {
        warning = 70;
        critical = 90;
      };
      tooltip = true;
    };

    cpu = {
      interval = 15;
      format = "CPU {usage:3}%";
      states = {
        warning = 70;
        critical = 90;
      };
      tooltip = true;
    };

    temperature = {
      thermal-zone = 2;
      critical-threshold = 80;
      interval = 15;
      format = "Tmp {temperatureC:2}°C";
      tooltip = true;
    };

    battery = {
      interval = 15;
      states = {
        warning = 30;
        critical = 15;
      };
      format = "Bat {capacity:3}%";
      format-charging = "Bat {capacity:2}%";
      tooltip = true;
    };

    tray = {
      icon-size = 15;
      spacing = 5;
      reverse-direction = true;
      show-passive-items = true;
    };

    pulseaudio = {
      format = "{volume:3}% {icon}  <span foreground='#${base03}'>│</span> {format_source}";
      format-bluetooth = "{volume:3}% {icon} <span foreground='#${base03}'>│</span> {format_source}";
      format-muted = "{volume:3}%   <span foreground='#${base03}'>│</span> {format_source}";
      format-source = "{volume:3}% ";
      format-source-muted = "{volume:3}% ";
      format-icons = {
        headphone = "";
        hands-free = "";
        headset = "";
        phone = "";
        portable = "";
        car = "";
        default = [
          ""
          ""
          ""
        ];
      };
      scroll-step = 1;
      on-click = "${volctl}";
      tooltip = false;
    };

    backlight = {
      device = "intel_backlight";
      format = "{percent:3}% {icon}";
      format-icons = [
        ""
        ""
        ""
        ""
        ""
        ""
        ""
        ""
        ""
      ];
    };

    network = {
      interval = 15;
      format-wifi = "{essid} - {signalStrength}%: {ipaddr}/{cidr}";
      format-ethernet = "{ifname}: {ipaddr}/{cidr}";
      format-disconnected = "No connection";
      tooltip = false;
      on-click = "${conctl}";
    };

    clock = {
      interval = 5;
      format = "{:%a %d.%m. %H:%M}";
      tooltip = false;
    };

    "custom/notification" = {
      tooltip = false;
      format = " {icon}";
      format-icons = {
        notification = "<span foreground='#${base08}'><small><sup>⬤</sup></small></span>";
        none = " ";
        dnd-notification = "<span foreground='#${base08}'><small><sup>⬤</sup></small></span>";
        dnd-none = " ";
      };
      return-type = "json";
      exec = "${swaync-client-raw} -swb";
      on-click = "${swaync-client} -t -sw";
      on-click-right = "${swaync-client} -d -sw";
      escape = true;
    };
  }
)
