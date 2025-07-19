{ pkgs, config, inputs, ... }:

let
  toRGBA = RGBhex: alpha:
    "rgba(${inputs.nix-colors.lib.conversions.hexToRGBString "," RGBhex}, ${builtins.toString alpha})";
in {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    # package = pkgs.firefox-nightly-bin.unwrapped;
    policies = {
      ExtensionSettings =
        let
          mkExtension = { name, uuid, area ? "menupanel", private ? false }: {
            name = uuid;
            value = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
              installation_mode = "normal_installed";
              default_area = area;
              private_browsing = private;
            };
          };
        in [
          { name = "darkreader"; uuid = "addon@darkreader.org"; }
          { name = "dictionary-german"; uuid = "de-DE@dictionaries.addons.mozilla.org"; }
          { name = "istilldontcareaboutcookies"; uuid = "idcac-pub@guus.ninja"; }
          { name = "keepassxc-browser"; uuid = "keepassxc-browser@keepassxc.org"; area = "navbar"; private = true; }
          { name = "ublock-origin"; uuid = "uBlock0@raymondhill.net"; private = true; }
          { name = "vimium-ff"; uuid = "{d7742d87-e61d-4b78-b8a1-b469842139fa}"; }
        ] |> builtins.map (ext: mkExtension ext) |> builtins.listToAttrs;
    };
    profiles.${config.home.username} = {
      isDefault = true;
      search = {
        default = "ddg";
        privateDefault = "ddg";
        force = true;
      };

      settings = {
        "browser.aboutConfig.showWarning" = false;
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.ctrlTab.sortByRecentlyUsed" = false;
        "browser.display.use_system_colors" = true;
        "browser.download.autohideButton" = false;
        "browser.fullscreen.autohide" = false;
        "browser.link.open_newwindow.restriction" = 0;
        "browser.ml.enable" = false;
        "browser.ml.chat.enabled" = false;
        "browser.urlbar.scotchBonnet.enableOverride" = false;
        "browser.search.separatePrivateDefault" = false;
        "browser.tabs.allow_transparent_browser" = true;
        "browser.tabs.closeWindowWithLastTab" = false;
        "browser.tabs.minWidth" = 55;
        "browser.tabs.warnOnClose" = true;
        "dom.security.https_only_mode" = true;
        "extensions.pocket.enabled" = false;
        "extensions.quarantinedDomains.enabled" = false;
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
        "browser.download.panel.shown" = true;
        "browser.feeds.showFirstRunUI" = false;
        "browser.messaging-system.whatsNewPanel.enabled" = false;
        "browser.rights.3.shown" = true;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.shell.defaultBrowserCheckCount" = 1;
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
      };

      userChrome = with config.colorScheme.palette; /* css */ ''
        :root[inFullscreen] #PersonalToolbar {
          visibility: visible !important;
        }
        .titlebar-buttonbox-container{ display:none } /* Remove close button */ 
        .titlebar-spacer[type="post-tabs"]{ display:none }

        :root {
          --toolbox-bgcolor: transparent !important;
          --tabpanel-background-color: transparent !important;
          --arrowpanel-background: #${base00} !important;
          --arrowpanel-color: #${base05} !important;
          --arrowpanel-border-color: #${base03} !important;
          --lwt-accent-color: transparent !important;
          --lwt-accent-color-inactive: transparent !important;
          --lwt-sidebar-background-color: #${base00} !important;
          --lwt-sidebar-text-color: #${base05} !important;
          --tab-selected-textcolor: #${base0E} !important;
          --tab-selected-bgcolor: transparent !important;
          --tab-selected-outline-color: #${base0E} !important;
          --tab-loading-fill: #${base0E} !important;
          --toolbarbutton-icon-fill-attention: #${base0E} !important;
          --toolbar-field-background-color: #${base00} !important;
          /* --toolbar-field-focus-color: #${base05} !important; */
          --toolbar-field-focus-background-color: #${base00} !important;
          --urlbarView-highlight-background: #${base02} !important;
          --urlbarView-highlight-color: #${base05} !important;

          --in-content-page-color: #${base05} !important;
          --in-content-page-background: #${base00} !important;
          --in-content-primary-button-background: #${base0E} !important;
          --in-content-primary-button-background-hover: ${toRGBA base0E 0.8} !important;
          --in-content-primary-button-background-active: ${toRGBA base0E 0.6} !important;
          --in-content-primary-button-text-color: #${base01} !important;

          --color-accent-primary: #${base0E} !important;
          --color-accent-primary-hover: ${toRGBA base0E 0.8} !important;
          --color-accent-primary-active: ${toRGBA base0E 0.6} !important;
          --focus-outline-color: #${base0E} !important;

          --button-text-color: #${base05} !important;
          --button-text-color-primary: #${base01} !important;

          --toolbar-bgcolor: #${base02} !important;
          --toolbar-color: #${base05} !important;

          --sidebar-background-color : #${base00} !important;
          --sidebar-border-color : #${base03} !important;
          --sidebar-text-color : #${base05} !important;

        }
        ::selection {
          background: ${toRGBA base0E 0.3} !important;
          color: #cad3f5 !important;
        }
        menupopup {
          --panel-background: #${base00} !important;
        }
      '';

      userContent = with config.colorScheme.palette; /* css */ ''
        @-moz-document url-prefix(about:blank), url-prefix(about:home), url-prefix(about:newtab) {
          body {
            background-color: transparent !important;
            color: #${base05} !important;
            --newtab-background-color-secondary: #${base02} !important;
            --newtab-primary-action-background: #${base0E} !important;
          }
        }
        body {
          --body-bg-color: #${base00} !important;
          --button-hover-color: #${base03} !important;
          --dropdown-btn-bg-color: #${base02} !important;
          --field-color: #${base05} !important;
          --field-bg-color: #${base02} !important;
          --field-border-color: #${base04} !important;
          --fxview-bg-color: transparent !important;
          --sidebar-toolbar-bg-color: #${base01} !important;
          --toolbar-bg-color: #${base02} !important;
          --toolbar-icon-bg-color: #${base05} !important;
          --toolbar-icon-hover-bg-color: #${base05} !important;
          --main-color: #${base05} !important;

          --doorhanger-bg-color: #${base02} !important;
          --doorhanger-border-color: #${base01} !important;
          --doorhanger-hover-bg-color: #${base03} !important;
          --doorhanger-seperator-color: #${base01} !important;

          --color-accent-primary: #${base0E} !important;
          --color-accent-primary-hover: ${toRGBA base0E 0.8} !important;
          --color-accent-primary-active: ${toRGBA base0E 0.6} !important;
          --focus-outline-color: #${base0E} !important;

          /* --in-content-page-color: #${base05} !important; */
          /* --in-content-page-background: #${base00} !important */
          /* --in-content-focus-outline-color: #${base0E} !important; */
          /**/
          /* --in-content-primary-button-background: #${base0E} !important; */
          /* --in-content-primary-button-background-hover: ${toRGBA base0E 0.8} !important; */
          /* --in-content-primary-button-background-active: ${toRGBA base0E 0.6} !important; */
          /* --in-content-primary-button-text-color: #${base01} !important; */
          /* --in-content-primary-button-text-color-hover: #${base01} !important; */
          /* --in-content-primary-button-text-color-active: #${base01} !important; */
          /**/
          /* --in-content-button-background: #${base04} !important; */
          /* --in-content-button-background-hover: #${toRGBA base04 0.8} !important; */
          /* --in-content-button-background-active: #${toRGBA base04 0.6} !important; */
          /* --in-content-button-text-color: #${base05} !important; */
          /* --in-content-button-text-color-hover: #${base05} !important; */
          /* --in-content-button-text-color-active: #${base05} !important; */
        }
        ::selection {
          background: ${toRGBA base0E 0.30 } !important;
        }
        p::-moz-selection {
          background: ${toRGBA base0E 0.30 } !important;
        }
        p::selection { 
          background: ${toRGBA base0E 0.30 } !important;
        }
        ::-moz-selection {
          background: ${toRGBA base0E 0.30 } !important;
        }
      '';
    };
  };
}
