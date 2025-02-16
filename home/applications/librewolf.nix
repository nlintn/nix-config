{ pkgs, config, inputs, userSettings, ... }:

let
  toRGBA = RGBhex: alpha:
    "rgba(${inputs.nix-colors.lib.conversions.hexToRGBString "," RGBhex}, ${builtins.toString alpha})";
in {
  programs.librewolf = {
    enable = true;
    package = pkgs.librewolf-wayland; 
    settings = {
      "browser.ctrlTab.sortByRecentlyUsed" = false;
      "browser.display.use_system_colors" = true;
      "browser.download.autohideButton" = false;
      "browser.fullscreen.autohide" = false;
      "browser.policies.runOncePerModification.removeSearchEngines" = "[\"Google\",\"Bing\",\"Amazon.com\",\"eBay\",\"Twitter\"]";
      "browser.policies.runOncePerModification.setDefaultSearchEngine" = "DuckDuckGo";
      "browser.search.separatePrivateDefault" = false;
      "browser.tabs.allow_transparent_browser" = true;
      "browser.tabs.closeWindowWithLastTab" = false;
      "dom.security.https_only_mode" = false;
      "identity.fxaccounts.enabled" = true;
      "intl.regional_prefs.use_os_locales" = true;
      "media.ffmpeg.vaapi.enabled" = true;
      "privacy.resistFingerprinting" = false;
      "sidebar.revamp" = true;
      "sidebar.verticalTabs" = true;
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "webgl.disabled" = false;

      "browser.search.suggest.enabled" = true;
      "browser.urlbar.suggest.quicksuggest.nonsponsored" = true;
      "browser.urlbar.suggest.searches" = true;
      "privacy.clearOnShutdown.cache" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "privacy.clearOnShutdown.downloads" = false;
      "privacy.clearOnShutdown.history" = false;

      "privacy.fingerprintingProtection" = true;
    };
  };
  home.file.".librewolf/profiles.ini".text = ''
    [General]
    StartWithLastProfile=1

    [Profile0]
    Name=nico
    IsRelative=1
    Path=nico
    Default=1
  '';
  home.file.".librewolf/nico/chrome/userChrome.css".text = with config.colorScheme.palette; /* css */ ''
    :root[inFullscreen] #PersonalToolbar {
      visibility: visible !important;
    }
    .titlebar-buttonbox-container{ display:none } /* Remove close button */ 
    .titlebar-spacer[type="post-tabs"]{ display:none }

    :root {
      /* --tabpanel-background-color: transparent !important; */
      --arrowpanel-background: #${base00} !important;
      --arrowpanel-color: #${base05} !important;
      --arrowpanel-border-color: #${base03} !important;
      --lwt-accent-color: transparent !important;
      --lwt-accent-color-inactive: transparent !important;
      --tab-selected-textcolor: #${base0E} !important;
      --tab-selected-bgcolor: transparent !important;
      --toolbarbutton-icon-fill-attention: #${base0E} !important;
      --toolbar-field-background-color: #${base00} !important;
      --toolbar-field-focus-color: #${base05} !important;
      --toolbar-field-focus-background-color: #${base00} !important;
      --urlbarView-highlight-background: #${base02} !important;

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

    }
    ::selection {
      background: ${toRGBA base0E 0.3} !important;
      color: #cad3f5 !important;
    }
    menupopup {
      --panel-background: #${base00} !important;
    }
  '';
  home.file.".librewolf/nico/chrome/userContent.css".text = with config.colorScheme.palette; /* css */ ''
    @-moz-document url-prefix(about:blank), url-prefix(about:home), url-prefix(about:newtab) {
      body {
        background-color: #${base00} !important;
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
}
