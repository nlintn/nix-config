{ config, pkgs, ... }:

let
  pkg_patched = pkgs.keepassxc.overrideAttrs (_: prev: {
    patches = prev.patches or [] ++ [
      ./0001-disable-config-access-error-message-on-config-load.patch
      ./0002-disable-save-changes-modal-on-database-lock.patch
    ];
  });
in {
  programs.keepassxc = {
    enable = true;
    package = pkg_patched.override { withKeePassKeeShare = false; withKeePassX11 = config.home.sessionVariables.X11_SUPPORT == "1"; };
    # Available Settings: https://github.com/keepassxreboot/keepassxc/blob/647272e9c5542297d3fcf6502e6173c96f12a9a0/src/core/Config.cpp#L49-L223
    settings = {
      General = {
        AutoSaveAfterEveryChange = false;
        AutoSaveOnExit = false;
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
        LockDatabaseIdle = false;
        LockDatabaseScreenLock = true;
        NoConfirmMoveEntryToRecycleBin = true;
        PasswordEmptyPlaceholder = true;
      };
    };
  };
}
