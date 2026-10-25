{
  assets,
  config,
  lib,
  lib-custom,
  ...
}:

let
  inherit (lib-custom.conversions) hexAToRGBA;
in
with config.colorScheme.palette;
/* css */ ''
  @-moz-document url-prefix(about:blank), url-prefix(about:home), url-prefix(about:newtab) {
    body, html {
      background-color: transparent !important;
    }
    .personalize-button {
      visibility: hidden !important;
    }
    .search-handoff-button {
      background-color: ${hexAToRGBA base02 0.5 |> toString} !important;
      color: #${base05} !important;
    }
  }
  @-moz-document url-prefix(about:), url-prefix(chrome:) {
    .logo {
      background-image: url('data:image/svg+xml;utf8,${
        lib.readFile assets."nix-snowflake-rainbow.svg" |> lib.escapeURL
      }') !important;
    }
    input {
      --input-text-background-color: #${base00} !important;
      --input-text-color: #${base05} !important;
    }
    treechildren::-moz-tree-row(current, focus) {
      outline: none !important;
    }
    dialog, .dialogBox {
      background-color: #${base01} !important;
    }
    .search-tooltip {
      background-color: #${base09} !important;
      border-color: #${base09} !important;
      color: #${base01} !important;
    }
    .search-tooltip::after {
      border-top-color: #${base09} !important;
    }
    .search-tooltip::before {
      border-top-color: #${base09} !important;
    }
    :root, .dialog-box {
      --input-bgcolor: #${base00} !important;
      --input-color: #${base05} !important;

      --newtab-background-color: ${hexAToRGBA base00 0.5 |> toString} !important;
      --newtab-background-color-secondary: ${hexAToRGBA base02 0.5 |> toString} !important;
      --newtab-primary-action-background: #${base0E} !important;
      --newtab-primary-action-background-dimmed: #${base0E} !important;

      --border-color-interactive: #${base03} !important;

      --body-bg-color: ${hexAToRGBA base00 0.5 |> toString} !important;
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
      --color-accent-primary-selected: #${base0E} !important;
      --color-accent-primary-hover: ${hexAToRGBA base0E 0.8 |> toString} !important;
      --color-accent-primary-active: ${hexAToRGBA base0E 0.6 |> toString} !important;
      --focus-outline-color: #${base0E} !important;

      --in-content-table-background: #${base00} !important;
      --in-content-box-border-color: #${base03} !important;
      --in-content-border-color: #${base03} !important;
      --in-content-border-invalid: #${base08} !important;
      --in-content-page-color: #${base05} !important;
      --in-content-primary-button-text-color: #${base01} !important;

      --outline-color-error: #${base08} !important;
      --info-bar-background-color: #${base00} !important;
      --info-bar-text-color: #${base05} !important;
      --text-color: #${base05} !important;
      --text-color-error: #${base08} !important;
      --background-color-box: #${base00} !important;
      --background-color-box-info: #${base00} !important;
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

    moz-message-bar {
      --message-bar-text-color: #${base01} !important;
      --message-bar-icon-color: #${base01} !important;
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
    background-color: ${hexAToRGBA base0E 0.35 |> toString} !important;
  }
  ::-moz-selection {
    background-color: ${hexAToRGBA base0E 0.35 |> toString} !important;
  }
  p::-moz-selection {
    background-color: ${hexAToRGBA base0E 0.35 |> toString} !important;
  }
  p::selection {
    background-color: ${hexAToRGBA base0E 0.35 |> toString} !important;
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
