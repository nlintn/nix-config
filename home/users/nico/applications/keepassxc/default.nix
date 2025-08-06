{ config, pkgs, ... }:

let
  pkg_patched = pkgs.keepassxc.overrideAttrs (_: prev: { patches = prev.patches ++ [ ./disable_config_access_error.patch ];});
in {
  programs.keepassxc = {
    enable = true;
    package = pkg_patched.override { withKeePassKeeShare = false; withKeePassX11 = (config.home.sessionVariables.ONLY_WAYLAND_SESSION or "0") != "1"; };
    # Available Settings: https://github.com/keepassxreboot/keepassxc/blob/647272e9c5542297d3fcf6502e6173c96f12a9a0/src/core/Config.cpp#L49-L223
    settings = {
      General = {
        AutoSaveAfterEveryChange = false;
        AutoSaveOnExit = true;
        AutoSaveNonDataChanges = false;
        BackupBeforeSave = true;
      };
      Browser = {
        Enabled = true;
        AllowExpiredCredentials = true;
        UpdateBinaryPath = false;
      };
      FdoSecrets = {
        Enabled = true;
      };
      GUI = {
        AdvancedSettings = true;
        ApplicationTheme = config.colorScheme.variant;
        CompactMode = true;
        MonospaceNotes = true;
        ShowTrayIcon = true;
        TrayIconAppearance = "colorful";
      };
      SSHAgent = {
        Enabled = true;
      };
      Security = {
        ClearClipboard = true;
        ClearClipboardTimeout = 25;
        ClearSearch = true;
        ClearSearchTimeout = 5;
        IconDownloadFallback = true;
        LockDatabaseIdle = true;
        LockDatabaseIdleSeconds = 600;
        LockDatabaseScreenLock = true;
        NoConfirmMoveEntryToRecycleBin = true;
        PasswordEmptyPlaceholder = true;
      };
    };
  };
}
