{
  config,
  lib,
  pkgs,
  userSettings,
  ...
}:

{
  vars =
    let
      swaylockPkg = config.programs.swaylock.package;
    in
    {
      lockCmd = "${lib.getExe' pkgs.procps "pidof"} ${swaylockPkg.NIX_MAIN_PROGRAM} || ${lib.getExe swaylockPkg}";
      unlockCmd = "${lib.getExe' pkgs.procps "pkill"} -SIGUSR1 ${swaylockPkg.NIX_MAIN_PROGRAM}";
    };
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;

    settings =
      with (with config.colorScheme.palette; {
        clearColor = base0A;
        insideColor = "${base00}60";
        lineColor = "${base01}60";
        rightColor = base0B;
        ringColor = "${base03}60";
        seperatorColor = "00000000";
        textColor = base05;
        verColor = base0E;
        wrongColor = base08;
      }); {
        daemonize = true;
        indicator = true;
        indicator-radius = 125;
        indicator-thickness = 20;
        clock = true;
        datestr = "%a, %d/%m/%y";
        timestr = "%X";
        font = userSettings.default-font.package;
        hide-keyboard-layout = true;
        image = userSettings.lockscreen;

        bs-hl-color = clearColor;
        inside-clear-color = insideColor;
        inside-color = insideColor;
        inside-ver-color = insideColor;
        inside-wrong-color = insideColor;
        key-hl-color = rightColor;
        line-clear-color = lineColor;
        line-color = lineColor;
        line-ver-color = lineColor;
        line-wrong-color = lineColor;
        ring-clear-color = clearColor;
        ring-color = ringColor;
        ring-ver-color = verColor;
        ring-wrong-color = wrongColor;
        separator-color = seperatorColor;
        text-caps-lock-color = textColor;
        text-clear-color = textColor;
        text-color = textColor;
        text-ver-color = textColor;
        text-wrong-color = wrongColor;
      };
  };
}
