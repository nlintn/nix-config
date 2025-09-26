{ config, lib, assets, nix-colors, ... }:

with config.colorScheme.palette; let
  toRGBA = RGBhex: alpha:
    "rgba(${nix-colors.lib.conversions.hexToRGBString "," RGBhex},${builtins.toString alpha})";
in /* css */ ''
  @-moz-document url-prefix(about:blank), url-prefix(about:home), url-prefix(about:newtab) {
    body, html {
      background-color: transparent !important;
    }
    .personalize-button {
      visibility: hidden !important;
    }
    .search-handoff-button {
      background-color: ${toRGBA base02 0.5} !important;
      color: #${base05} !important;
    }
  }
  @-moz-document url-prefix(about:) {
    .logo {
      background-image: url('data:image/svg+xml;utf8,${builtins.readFile assets."nix-snowflake-rainbow.svg" |> lib.escapeURL}') !important;
    }
    input {
      --input-text-background-color: #${base00} !important;
      --input-text-color: #${base05} !important;
    }
    :root {
      --newtab-background-color: ${toRGBA base00 0.5} !important;
      --newtab-background-color-secondary: #${toRGBA base02 0.5} !important;
      --newtab-primary-action-background: #${base0E} !important;
      --newtab-primary-action-background-dimmed: #${base0E} !important;

      --border-color-interactive: #${base03} !important;

      --body-bg-color: ${toRGBA base00 0.5} !important;
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

      --in-content-border-color: #${base03} !important;
      --in-content-border-invalid: #${base08} !important;
      --in-content-page-color: #${base05} !important;
      --in-content-primary-button-text-color: #${base01} !important;

      --outline-color-error: #${base08} !important;
      --text-color: #${base05} !important;
      --text-color-error: #${base08} !important;
      --background-color-box: #${base00} !important;
      --background-color-canvas: #${base01} !important;
      --background-color-critical: #${base08} !important;
      --background-color-information: #${base0D} !important;
      --background-color-success: #${base0B} !important;
      --background-color-warning: #${base09} !important;
      --border-color: #${base03} !important;
      --button-background-color-primary: #${base0E} !important;
      --attention-dot-color: #${base0B} !important;
      --button-text-color: #${base05} !important;
      --button-text-color-primary: #${base01} !important;

      --table-row-background-color-alternate: var(--background-color-box) !important;
    }
  }
  :root {
    --vimium-background-color: #${base01} !important;
    --vimium-background-text-color: #${base04} !important;
    --vimium-foreground-color: #${base00} !important;
    --vimium-foreground-text-color: #${base05} !important;
    --vimium-link-color: #${base0E} !important;
  }
  ::selection {
    background-color: ${toRGBA base0E 0.35} !important;
  }
  ::-moz-selection {
    background-color: ${toRGBA base0E 0.35} !important;
  }
  p::-moz-selection {
    background-color: ${toRGBA base0E 0.35} !important;
  }
  p::selection {
    background-color: ${toRGBA base0E 0.35} !important;
  }

  div > .vimiumHintMarker {
    padding: 2px 3px !important;
    background-color: #${base09} !important;
    border: 0 !important;
    border-radius: 2px !important;
    background-image: none !important;
  }
  
  div > .vimiumHintMarker span {
    font-size: 11px !important;
    font-weight: bold !important;
    text-shadow: none !important;
    color: #${base01} !important;
  }
  
  div > .vimiumHintMarker > .matchingCharacter {
    background-color: #${base00} !important;
    color: #${base05} !important;
  }
''
