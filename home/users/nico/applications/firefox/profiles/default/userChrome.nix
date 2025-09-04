{ config, nix-colors, ... }:

with config.colorScheme.palette; let
  toRGBA = RGBhex: alpha:
    "rgba(${nix-colors.lib.conversions.hexToRGBString "," RGBhex},${builtins.toString alpha})";
in /* css */ ''
  :root:not([chromehidden~="toolbar"]) {
    min-width: 20px !important;
  }
  :root[inFullscreen] #PersonalToolbar {
    visibility: visible !important;
  }
  .titlebar-buttonbox-container{ display:none } /* Remove close button */
  .titlebar-spacer[type="post-tabs"]{ display:none }

  :root {
    --toolbox-bgcolor: transparent !important;
    --toolbox-bgcolor-inactive: transparent !important;
    --toolbox-textcolor: #${base05} !important;
    --toolbox-textcolor-inactive: ${toRGBA base05 0.8} !important;
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
    --toolbar-field-color: #${base05} !important;
    --toolbar-field-background-color: #${base00} !important;
    --toolbar-field-focus-color: #${base05} !important;
    --toolbar-field-focus-background-color: #${base00} !important;
    --toolbar-field-focus-border-color: #${base0E} !important;
    --urlbarView-highlight-background: #${base02} !important;
    --urlbarView-highlight-color: #${base05} !important;

    --in-content-page-color: #${base05} !important;
    --in-content-page-background: #${base00} !important;
    --in-content-primary-button-background: #${base0E} !important;
    --in-content-primary-button-background-hover: ${toRGBA base0E 0.8} !important;
    --in-content-primary-button-background-active: ${toRGBA base0E 0.6} !important;
    --in-content-primary-button-text-color: #${base01} !important;

    --button-text-color: #${base05} !important;
    --button-text-color-primary: #${base01} !important;

    --toolbar-bgcolor: #${base02} !important;
    --toolbar-color: #${base05} !important;

    --sidebar-background-color : #${base00} !important;
    --sidebar-border-color : #${base03} !important;
    --sidebar-text-color : #${base05} !important;

    --color-accent-primary: #${base0E} !important;
    --color-accent-primary-hover: ${toRGBA base0E 0.8} !important;
    --color-accent-primary-active: ${toRGBA base0E 0.6} !important;
    --background-color-box: #${base00} !important;
    --background-color-canvas: #${base01} !important;
    --background-color-critical: #${base08} !important;
    --background-color-information: #${base0D} !important;
    --background-color-success: #${base0B} !important;
    --background-color-warning: #${base09} !important;
    --border-color: #${base03} !important;
  }

  ::selection {
    background-color: #${base0E} !important;
    color: #${base01} !important;
  }

  menupopup {
    --panel-background: #${base00} !important;
    --panel-color: #${base05} !important;
    --panel-border-color: #${base03} !important;
  }
  menu, menuitem {
    &:where([_moz-menuactive]:not([disabled="true"])) {
      color: #${base05} !important;
      background-color: #${base02} !important;
    }
  }
  splitter#sidebar-tools-and-extensions-splitter {
    border-color: #${base03} !important;
  }

  @-moz-document url(chrome://browser/content/places/places.xhtml) {
    input {
      color: #${base05} !important;
      background-color: #${base02} !important;
      border-color: #${base03} !important;
      &::placeholder {
        color: #${base04} !important;
      }
    }
    treecol {
      background-color: #${base01} !important;
      color: #${base05} !important;
    }
    treechildren {
      color: #${base05} !important;
      background-color: #${base00} !important;
    }
    #placesView {
      background-color: #${base01} !important;
      color: #${base05} !important;
    }
    #placesToolbar {
      background-color: #${base01} !important;
      color: #${base05} !important;
    }
    #placesContent {
      color: #${base05} !important;
      background-color: #${base00} !important;
    }
    #placesMenu {
      color: #${base05} !important;
    }
    #placesMenu > menu {
      color: #${base05} !important;
      &:hover {
        background-color: #${base00} !important;
        border-color: #${base04} !important;
        color: #${base05} !important;
      }
    }
    html:input {
      color: #${base05} !important;
      background-color: #${base01} !important;
      border-color: #${base03} !important;
    }
    toolbarbutton {
      color: #${base05} !important;
      &:where([disabled="true"]) {
        color: #${base04} !important;
      }
    }
    splitter {
      background-color: #${base01} !important;
      border-color: #${base03} !important;
    }
  }
''
