{
  config,
  lib,
  pkgs,
  ...
}:

{
  force = true;
  packages = with pkgs.firefoxAddons; [
    darkreader
    dictionary-german
    (lib.mkIf config.programs.keepassxc.enable keepassxc-browser)
    simplelogin
    tabwrangler
    ublock-origin
    (lib.mkIf config.programs.vicinae.enable vicinae)
    video-downloadhelper
    vimium-ff
    violentmonkey
  ];

  settings =
    let
      settings = with config.colorScheme.palette; {
        darkreader.settings = {
          "enabledByDefault" = false;
          "installation" = {
            "date" = 0;
            "reason" = "install";
            "version" = "4.9.110";
          };
          "syncSettings" = false;
          "schemeVersion" = 2;
        };
        ublock-origin.settings = {
          "selectedFilterLists" = [
            "user-filters"
            "ublock-filters"
            "ublock-badware"
            "ublock-privacy"
            "ublock-quick-fixes"
            "ublock-unbreak"
            "ublock-experimental"
            "easylist"
            "easyprivacy"
            "urlhaus-1"
            "plowe-0"
            "fanboy-cookiemonster"
            "ublock-cookies-easylist"
            # "fanboy-social" "easylist-chat" "easylist-newsletters" "easylist-notifications" "easylist-annoyances"
            "DEU-0"
          ];
          "uiAccentCustom" = true;
          "uiAccentCustom0" = "#${base0E}";
          "hostnameSwitchesString" = "no-csp-reports: * true\nno-large-media: behind-the-scene false";
          "advancedUserEnabled" = true;
          "dynamicFilteringString" =
            "* * 3p-script block\n* * 3p-frame block\nbehind-the-scene * * noop\nbehind-the-scene * inline-script noop\nbehind-the-scene * 1p-script noop\nbehind-the-scene * 3p-script noop\nbehind-the-scene * 3p-frame noop\nbehind-the-scene * image noop\nbehind-the-scene * 3p noop";
          "popupPanelSections" = 31;
        };
        violentmonkey.settings = {
          "options" = {
            "badgeColor" = "#${base0E}";
            "badgeColorBlocked" = "#${base04}";
          };
          "scr:1" = {
            "custom" = {
              "origInclude" = true;
              "origExclude" = true;
              "origMatch" = true;
              "origExcludeMatch" = true;
              "pathMap" = { };
            };
            "config" = {
              "enabled" = 1;
              "shouldUpdate" = 1;
              "removed" = 0;
            };
            "meta" = {
              "include" = [ ];
              "exclude" = [ ];
              "match" = [
                "*://*/*"
              ];
              "excludeMatch" = [ ];
              "require" = [ ];
              "grant" = [ ];
              "name" = "Bootstrap Dark Mode";
              "namespace" = "Violentmonkey Scripts";
              "resources" = { };
            };
            "props" = {
              "id" = 1;
              "lastModified" = 1756424337991;
              "uuid" = "bbc1df0b-925b-40f4-a787-ccdc3221212e";
              "position" = 1;
              "uri" = "Violentmonkey-20Scripts-0aBootstrap-20Dark-20Mode-0a";
              "lastUpdated" = 1756424337991;
            };
          };
          "code:1" = /* js */ ''
            (function() { document.documentElement.setAttribute('data-bs-theme', 'dark'); })();
          '';
        };
      };
    in
    lib.attrNames settings
    |> lib.map (n: {
      name = pkgs.firefoxAddons.${n}.addonId;
      value = settings.${n};
    })
    |> lib.listToAttrs;
}
