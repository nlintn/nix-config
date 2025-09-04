{ pkgs, ... }:

let
  settings = {
    keepassxc-browser = {
      "settings" = {
        "autoReconnect" = true;
        "afterFillSorting" = "sortByMatchingCredentials";
        "afterFillSortingTotp" = "sortByRelevantEntry";
        "autoCompleteUsernames" = true;
        "autoFillAndSend" = false;
        "autoFillSingleEntry" = false;
        "autoFillRelevantCredential" = false;
        "autoFillSingleTotp" = true;
        "autoRetrieveCredentials" = true;
        "autoSubmit" = false;
        "bannerPosition" = 1;
        "checkUpdateKeePassXC" = 0;
        "clearCredentialsTimeout" = 10;
        "colorTheme" = "system";
        "credentialSorting" = "sortByGroupAndTitle";
        "debugLogging" = false;
        "defaultGroup" = "";
        "defaultPasskeyGroup" = "";
        "defaultPasswordManager" = true;
        "defaultGroupAlwaysAsk" = false;
        "downloadFaviconAfterSave" = true;
        "passkeys" = false;
        "passkeysFallback" = true;
        "redirectAllowance" = 11;
        "saveDomainOnly" = true;
        "showGettingStartedGuideAlert" = true;
        "showGroupNameInAutocomplete" = true;
        "showLoginFormIcon" = true;
        "showLoginNotifications" = true;
        "showNotifications" = true;
        "showOTPIcon" = true;
        "showTroubleshootingGuideAlert" = true;
        "useCompactMode" = false;
        "useMonochromeToolbarIcon" = false;
        "useObserver" = true;
        "usePredefinedSites" = true;
        "usePasswordGeneratorIcons" = true;
        "sitePreferences" = [];
      };
    };
  };
in
  builtins.attrNames settings |>
  builtins.map (n: { name = pkgs.firefoxAddons.${n}.addonId; value = settings.${n}; }) |>
  builtins.listToAttrs
