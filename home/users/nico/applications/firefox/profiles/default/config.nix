{
  config,
  lib,
  pkgs,
  ...
}:

with config.colorScheme.palette;
{
  # extensions
  "extensions.autoDisableScopes" = 0;
  "extensions.update.autoUpdateDefault" = false;
  "extensions.update.enabled" = false;

  # memory
  "browser.low_commit_space_threshold_percent" = 50;
  "browser.tabs.min_inactive_duration_before_unload" = 1800000;
  "browser.tabs.unloadOnLowMemory" = true;

  # disable ml
  "browser.ml.chat.enabled" = false;
  "browser.ml.chat.menu" = false;
  "browser.ml.chat.page" = false;
  "browser.ml.chat.shortcuts" = false;
  "browser.ml.chat.sidebar" = false;
  "browser.ml.enable" = false;
  "browser.ml.linkPreview.collapsed" = true;
  "browser.ml.linkPreview.optin" = false;
  "browser.tabs.groups.smart.enabled" = false;
  "browser.tabs.groups.smart.userEnabled" = false;
  "extensions.ml.enabled" = false;
  "extensions.ml.linkPreview.enabled" = true;

  # sidebar
  "browser.tabs.tabMinWidth" = 55;
  "sidebar.expandOnHover" = true;
  "sidebar.main.tools" = "syncedtabs,history,bookmarks";
  "sidebar.revamp" = true;
  "sidebar.revamp.round-content-area" = true;
  "sidebar.verticalTabs" = true;
  "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
  "sidebar.visibility" = "expand-on-hover";

  "accessibility.browsewithcaret" = true;
  "browser.aboutConfig.showWarning" = false;
  "browser.bookmarks.addedImportButton" = true;
  "browser.bookmarks.restore_default_bookmarks" = false;
  "browser.ctrlTab.sortByRecentlyUsed" = false;
  "browser.disableResetPrompt" = true;
  "browser.display.use_system_colors" = true;
  "browser.download.alwaysOpenPanel" = true;
  "browser.download.autohideButton" = false;
  "browser.download.lastDir" = config.xdg.userDirs.download;
  "browser.download.panel.shown" = true;
  "browser.feeds.showFirstRunUI" = false;
  "browser.fullscreen.autohide" = true;
  "browser.link.open_newwindow.restriction" = 0;
  "browser.messaging-system.whatsNewPanel.enabled" = false;
  "browser.rights.3.shown" = true;
  "browser.search.separatePrivateDefault" = false;
  "browser.shell.checkDefaultBrowser" = false;
  "browser.shell.defaultBrowserCheckCount" = 1;
  "browser.startup.couldRestoreSession.count" = 2;
  "browser.startup.homepage_override.mstone" = "ignore";
  "browser.tabs.allow_transparent_browser" = true;
  "browser.tabs.closeWindowWithLastTab" = false;
  "browser.tabs.splitView.enabled" = true;
  "browser.tabs.warnOnClose" = true;
  "browser.toolbars.bookmarks.visibility" = "never";
  "browser.translations.neverTranslateLanguages" = "de";
  "browser.uitour.enabled" = false;
  "dom.security.https_only_mode" = false;
  "extensions.pocket.enabled" = false;
  "extensions.quarantinedDomains.enabled" = false;
  "extensions.webextensions.restrictedDomains" = "";
  "general.autoScroll" = true;
  "general.smoothScroll" = true;
  "identity.fxaccounts.enabled" = true;
  "intl.regional_prefs.use_os_locales" = true;
  "media.ffmpeg.vaapi.enabled" = true;
  "media.webrtc.camera.allow-pipewire" = true;
  "signon.rememberSignons" = false;
  "startup.homepage_override_url" = "";
  "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  "trailhead.firstrun.didSeeAboutWelcome" = true;
  "ui.prefersReducedMotion" = 1;
  "webgl.disabled" = false;

  # newtab page activity-stream
  "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
  "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
  "browser.newtabpage.activity-stream.discoverystream.enabled" = false;
  "browser.newtabpage.activity-stream.feeds.sections" = false;
  "browser.newtabpage.activity-stream.feeds.topsites" = false;
  "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
  "browser.newtabpage.activity-stream.showRecentSaves" = false;
  "browser.newtabpage.activity-stream.showSponsored" = false;
  "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
  "browser.newtabpage.activity-stream.showWeather" = false;

  # Disable some telemetry
  "app.shield.optoutstudies.enabled" = false;
  "browser.discovery.enabled" = false;
  "browser.newtabpage.activity-stream.feeds.telemetry" = false;
  "browser.newtabpage.activity-stream.telemetry" = false;
  "browser.ping-centre.telemetry" = false;
  "datareporting.healthreport.service.enabled" = false;
  "datareporting.healthreport.uploadEnabled" = false;
  "datareporting.policy.dataSubmissionEnabled" = false;
  "datareporting.sessions.current.clean" = true;
  "devtools.onboarding.telemetry.logged" = false;
  "toolkit.telemetry.archive.enabled" = false;
  "toolkit.telemetry.bhrPing.enabled" = false;
  "toolkit.telemetry.enabled" = false;
  "toolkit.telemetry.firstShutdownPing.enabled" = false;
  "toolkit.telemetry.hybridContent.enabled" = false;
  "toolkit.telemetry.newProfilePing.enabled" = false;
  "toolkit.telemetry.prompted" = 2;
  "toolkit.telemetry.rejected" = true;
  "toolkit.telemetry.reportingpolicy.firstRun" = false;
  "toolkit.telemetry.server" = "";
  "toolkit.telemetry.shutdownPingSender.enabled" = false;
  "toolkit.telemetry.unified" = false;
  "toolkit.telemetry.unifiedIsOptIn" = false;
  "toolkit.telemetry.updatePing.enabled" = false;

  # URL bar
  "browser.search.suggest.enabled" = true;
  "browser.urlbar.scotchBonnet.enableOverride" = false;
  "browser.urlbar.showSearchTerms.enabled" = false;
  "browser.urlbar.suggest.quicksuggest.nonsponsored" = true;
  "browser.urlbar.suggest.searches" = true;
  "browser.urlbar.trimHttps" = false;
  "browser.urlbar.trimURLs" = false;

  # Privacy and fingerprinting protection
  "geo.enabled" = false;
  "geo.prompt.open_system_prefs" = false;
  "privacy.antitracking.isolateContentScriptResources" = true;
  "privacy.clearOnShutdown.cache" = false;
  "privacy.clearOnShutdown.cookies" = false;
  "privacy.clearOnShutdown.downloads" = false;
  "privacy.clearOnShutdown.history" = false;
  "privacy.fingerprintingProtection" = true;
  "privacy.fingerprintingProtection.pbmode" = true;
  "privacy.fingerprintingProtection.overrides" =
    "+AllTargets,-CSSPrefersColorScheme,-JSDateTimeUTC,-FontVisibilityRestrictGenerics";
  "privacy.resistFingerprinting" = false; # unwanted side effects
  "privacy.resistFingerprinting.pbmode" = true;
  "privacy.resistFingerprinting.randomization.canvas.use_siphash" = true;
  "privacy.resistFingerprinting.randomization.daily_reset.enabled" = true;
  "privacy.resistFingerprinting.randomization.daily_reset.private.enabled" = true;
  "privacy.trackingprotection.cryptomining.enabled" = true;
  "privacy.trackingprotection.enabled" = true;
  "privacy.trackingprotection.fingerprinting.enabled" = true;
  "privacy.trackingprotection.socialtracking.enabled" = true;

  # devtools
  "devtools.chrome.enabled" = true;
  "devtools.debugger.remote-enabled" = true;
  "devtools.serviceWorkers.testing.enabled" = true;

  "network.trr.mode" = 5;

  # Sync settings
  "services.sync.engine.addons" = false;
  "services.sync.engine.addresses" = true;
  "services.sync.engine.addresses.available" = true;
  "services.sync.engine.bookmarks" = true;
  "services.sync.engine.creditcards" = true;
  "services.sync.engine.creditcards.available" = true;
  "services.sync.engine.history" = true;
  "services.sync.engine.passwords" = true;
  "services.sync.engine.prefs" = false;
  "services.sync.engine.prefs.modified" = false;
  "services.sync.engine.tabs" = true;

  # UI colors
  "ui.textHighlightBackground" = "#${base09}";
  "ui.textHighlightForeground" = "#${base01}";
  "ui.textSelectAttentionBackground" = "#${base08}";
  "ui.textSelectAttentionForeground" = "#${base01}";

  # UI layout settings
  "browser.uiCustomization.navBarWhenVerticalTabs" = [
    "firefox-view-button"
    "back-button"
    "forward-button"
    "vertical-spacer"
    "urlbar-container"
    "customizableui-special-spring1"
    "downloads-button"
    "keepassxc-browser_keepassxc_org-browser-action"
    "unified-extensions-button"
    "fxa-toolbar-menu-button"
  ];
  "browser.uiCustomization.state" =
    let
      extToBrowserAction = lib.map (
        n:
        if lib.typeOf n == "string" then
          n
        else
          (
            n.addonId
            |> (
              let
                replaceChars = [
                  "{"
                  "}"
                  "@"
                  "."
                ];
              in
              lib.replaceStrings (replaceChars ++ lib.upperChars) (
                lib.genList (_: "_") (lib.length replaceChars) ++ lib.lowerChars
              )
            )
            |> (s: "${s}-browser-action")
          )
      );
    in
    {
      "placements" = with pkgs.firefoxAddons; {
        "widget-overflow-fixed-list" = [ ];
        "unified-extensions-area" = extToBrowserAction [
          ublock-origin
          tabwrangler
          darkreader
          vimium-ff
          violentmonkey
          simplelogin
          video-downloadhelper
        ];
        "nav-bar" = extToBrowserAction [
          "sidebar-button"
          "firefox-view-button"
          # "alltabs-button"
          "back-button"
          "forward-button"
          "vertical-spacer"
          "urlbar-container"
          "customizableui-special-spring1"
          "downloads-button"
          keepassxc-browser
          "unified-extensions-button"
          "fxa-toolbar-menu-button"
          # "developer-button"
          # "history-panelmenu"
        ];
        "toolbar-menubar" = [ "menubar-items" ];
        "TabsToolbar" = [ ];
        "vertical-tabs" = [ "tabbrowser-tabs" ];
        "PersonalToolbar" = [ "personal-bookmarks" ];
      };
      "dirtyAreaCache" = [ ];
      "currentVersion" = 23;
      "newElementCount" = 0;
    };
}
