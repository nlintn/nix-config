{ config, lib, pkgs, ... }:

{
  "extensions.autoDisableScopes" = 0;
  "extensions.update.autoUpdateDefault" = false;
  "extensions.update.enabled" = false;

  "browser.tabs.unloadOnLowMemory" = true;
  "browser.low_commit_space_threshold_percent" = 50;
  "browser.tabs.min_inactive_duration_before_unload" = 1800000;

  "accessibility.browsewithcaret" = true;
  "browser.aboutConfig.showWarning" = false;
  "browser.toolbars.bookmarks.visibility" = "never";
  "browser.ctrlTab.sortByRecentlyUsed" = false;
  "browser.display.use_system_colors" = true;
  "browser.download.alwaysOpenPanel" = true;
  "browser.download.autohideButton" = false;
  "browser.download.panel.shown" = true;
  "browser.download.lastDir" = config.xdg.userDirs.download;
  "browser.fullscreen.autohide" = false;
  "browser.link.open_newwindow.restriction" = 0;
  "browser.ml.enable" = false;
  "browser.ml.chat.enabled" = false;
  "browser.ml.chat.menu" = false;
  "browser.ml.chat.page" = false;
  "browser.urlbar.scotchBonnet.enableOverride" = false;
  "browser.search.separatePrivateDefault" = false;
  "browser.tabs.allow_transparent_browser" = true;
  "browser.tabs.closeWindowWithLastTab" = false;
  "browser.tabs.minWidth" = 55;
  "browser.tabs.warnOnClose" = true;
  "browser.translations.neverTranslateLanguages" = "de";
  "dom.security.https_only_mode" = true;
  "extensions.pocket.enabled" = false;
  "extensions.quarantinedDomains.enabled" = false;
  "extensions.webextensions.restrictedDomains" = "";
  "general.autoScroll" = true;
  "general.smoothScroll" = true;
  "identity.fxaccounts.enabled" = true;
  "intl.regional_prefs.use_os_locales" = true;
  "media.ffmpeg.vaapi.enabled" = true;
  "privacy.resistFingerprinting" = false;
  "sidebar.revamp" = true;
  "sidebar.revamp.round-content-area" = true;
  "sidebar.verticalTabs" = true;
  "signon.rememberSignons" = false;
  "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  "ui.prefersReducedMotion" = 1;
  "webgl.disabled" = false;

  "browser.disableResetPrompt" = true;
  "browser.feeds.showFirstRunUI" = false;
  "browser.messaging-system.whatsNewPanel.enabled" = false;
  "browser.rights.3.shown" = true;
  "browser.shell.checkDefaultBrowser" = false;
  "browser.shell.defaultBrowserCheckCount" = 1;
  "browser.startup.couldRestoreSession.count" = 2;
  "browser.startup.homepage_override.mstone" = "ignore";
  "browser.uitour.enabled" = false;
  "startup.homepage_override_url" = "";
  "trailhead.firstrun.didSeeAboutWelcome" = true;
  "browser.bookmarks.restore_default_bookmarks" = false;
  "browser.bookmarks.addedImportButton" = true;

  "browser.newtabpage.activity-stream.feeds.sections" = false;
  "browser.newtabpage.activity-stream.discoverystream.enabled" = false;
  "browser.newtabpage.activity-stream.showRecentSaves" = false;
  "browser.newtabpage.activity-stream.showSponsored" = false;
  "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
  "browser.newtabpage.activity-stream.showWeather" = false;
  "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
  "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
  "browser.newtabpage.activity-stream.feeds.topsites" = false;
  "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;

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

  "browser.search.suggest.enabled" = true;
  "browser.urlbar.suggest.quicksuggest.nonsponsored" = true;
  "browser.urlbar.suggest.searches" = true;
  "browser.urlbar.trimURLs" = false;
  "browser.urlbar.trimHttps" = false;
  "browser.urlbar.showSearchTerms.enabled" = false;

  "privacy.clearOnShutdown.cache" = false;
  "privacy.clearOnShutdown.cookies" = false;
  "privacy.clearOnShutdown.downloads" = false;
  "privacy.clearOnShutdown.history" = false;

  "privacy.fingerprintingProtection" = true;
  "privacy.trackingprotection.enabled" = true;
  "privacy.trackingprotection.cryptomining.enabled" = true;
  "privacy.trackingprotection.fingerprinting.enabled" = true;
  "privacy.trackingprotection.socialtracking.enabled" = true;

  "devtools.chrome.enabled" = true;
  "devtools.debugger.remote-enabled" = true;
  "devtools.serviceWorkers.testing.enabled" = true;

  "network.trr.mode" = 5;

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

  "browser.uiCustomization.state" = let
    extToBrowserAction =
      builtins.map (n: if builtins.typeOf n == "string" then n else (
        n.addonId
        |> (let replaceChars = [ "{" "}" "@" "." ];
          in builtins.replaceStrings (replaceChars ++ lib.upperChars) (builtins.genList (_: "_") (builtins.length replaceChars) ++ lib.lowerChars))
        |> (s: "${s}-browser-action")
      ));
  in {
    "placements" = with pkgs.firefoxAddons; {
      "widget-overflow-fixed-list" = [];
      "unified-extensions-area" = extToBrowserAction [
        ublock-origin
        darkreader
        vimium-ff
        violentmonkey
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
      "TabsToolbar"= [];
      "vertical-tabs"= [ "tabbrowser-tabs" ];
      "PersonalToolbar"= [ "personal-bookmarks" ];
    };
    "dirtyAreaCache" = [];
    "currentVersion" = 23;
    "newElementCount" = 0;
  };
}
