{ config, lib, pkgs, nix-colors, ... } @ args:

{
  programs.wlogout = {
    enable = true;
    layout = let
      loginctl  = config.systemd.user.loginctlPath;
      systemctl = config.systemd.user.systemctlPath;
    in [
      {
        "label" = "lock";
        "action" = "${config.vars.sessionLockCmd}";
        "text" = "Lock";
        "keybind" = "l";
      }
      {
        "label" = "hibernate";
        "action" = "${systemctl} hibernate";
        "text" = "Hibernate";
        "keybind" = "h";
      }
      {
        "label" = "logout";
        "action" = "${loginctl} terminate-user $UID";
        "text" = "Logout";
        "keybind" = "e";
      }
      {
        "label" = "shutdown";
        "action" = "${systemctl} poweroff";
        "text" = "Shutdown";
        "keybind" = "s";
      }
      {
        "label" = "suspend";
        "action" = "${systemctl} suspend";
        "text" = "Suspend";
        "keybind" = "u";
      }
      {
        "label" = "reboot";
        "action" = "${systemctl} reboot";
        "text" = "Reboot";
        "keybind" = "r";
      }
    ];
    style = let
      toRGBA = RGBhex: alpha:
        "rgba(${nix-colors.lib.conversions.hexToRGBString "," RGBhex},${builtins.toString alpha})";
      icon = x: "url(\"${import ./icons/${x}.nix args |> lib.replaceString "\n" "" |> pkgs.writeText "${x}.svg"}\"),
        url(\"${config.programs.wlogout.package}/share/wlogout/icons/${x}.png\")";
    in with config.colorScheme.palette; ''
      * {
        background-image: none;
        box-shadow: none;
      }

      window {
        background-color: ${toRGBA base00 0.2};
      }

      button {
        border-radius: 0px;
        border-color: ${toRGBA base04 0.8};
        text-decoration-color: #${base05};
        color: #${base05};
        background-color: ${toRGBA base01 0.7};
        border-style: solid;
        border-width: 1px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
      }

      button:focus, button:active {
        background-color: ${toRGBA base02 0.7};
        outline-style: none;
        background-size: 30%;
      }

      #lock {
        background-image: image(${icon "lock"});
      }

      #logout {
        background-image: image(${icon "logout"});
      }

      #suspend {
        background-image: image(${icon "suspend"});
      }

      #hibernate {
        background-image: image(${icon "hibernate"});
      }

      #shutdown {
        background-image: image(${icon "shutdown"});
      }

      #reboot {
        background-image: image(${icon "reboot"});
      }
    '';
  };


}
