{
  lib,
  ...
}:

{
  services.logind.settings.Login = {
    HandlePowerKey = "sleep";
    HandleLidSwitch = "sleep";
  };
  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "24h";
  };

  xdg.autostart.enable = lib.mkForce false;

  services.displayManager.ly = {
    enable = true;
    settings = {
      battery_id = "BAT1";
      clear_password = true;
      clock = "%a %Y/%m/%d %H:%M";
      # ly_log = null; TODO: add when available
      session_log = ".local/state/ly-session.log";

      animation = "colormix";
      animation_frame_delay = 50;
      animation_timeout_sec = 60;
      bg = "0x00000001";
      border_fg = "0x00000006";
      colormix_col1 = "0x01000006";
      colormix_col2 = "0x00000001";
      colormix_col3 = "0x00000008";
      error_bg = "0x00000002";
      error_fg = "0x01000001";
      fg = "0x00000008";
      full_color = false;
    };
  };
}
