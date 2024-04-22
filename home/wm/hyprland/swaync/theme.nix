{ config, userSettings }:

with config.colorScheme.palette; /* css */ ''
  * {
    all: unset;
    font-size: 14px;
    font-family: "${userSettings.default-font}";
    transition: 200ms;
  }
  
  trough highlight {
    background: #${base05};
  }
  
  scale trough {
    margin: 0rem 1rem;
    background-color: #${base02};
    min-height: 8px;
    min-width: 70px;
  }
  
  slider {
    background-color: #${base0D};
  }
  
  .floating-notifications.background .notification-row .notification-background {
    box-shadow: 0 0 8px 0 rgba(0, 0, 0, 0.8), inset 0 0 0 1px #${base02};
    border-radius: 12.6px;
    margin: 18px;
    background-color: #${base00};
    color: #${base05};
    padding: 0;
  }
  
  .floating-notifications.background .notification-row .notification-background .notification {
    padding: 7px;
    border-radius: 12.6px;
  }
  
  .floating-notifications.background .notification-row .notification-background .notification.critical {
    box-shadow: inset 0 0 7px 0 #${base08};
  }
  
  .floating-notifications.background .notification-row .notification-background .notification .notification-content {
    padding-left: 7px;
    margin: 7px;
  }
  
  .floating-notifications.background .notification-row .notification-background .notification .notification-content .summary {
    color: #${base05};
  }
  
  .floating-notifications.background .notification-row .notification-background .notification .notification-content .time {
    color: #${base05};
  }
  
  .floating-notifications.background .notification-row .notification-background .notification .notification-content .body {
    color: #${base05};
  }
  
  .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * {
    min-height: 3.4em;
  }
  
  .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action {
    border-radius: 7px;
    color: #${base05};
    background-color: #${base02};
    box-shadow: inset 0 0 0 1px #${base03};
    margin: 7px;
  }
  
  .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action:hover {
    box-shadow: inset 0 0 0 1px #${base03};
    background-color: #${base02};
    color: #${base05};
  }
  
  .floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action:active {
    box-shadow: inset 0 0 0 1px #${base03};
    background-color: #${base07};
    color: #${base05};
  }
  
  .floating-notifications.background .notification-row .notification-background .close-button {
    margin: 7px;
    padding: 2px;
    border-radius: 6.3px;
    color: #${base00};
    background-color: #${base08};
  }
  
  .floating-notifications.background .notification-row .notification-background .close-button:hover {
    background-color: #${base08};
    color: #${base00};
  }
  
  .floating-notifications.background .notification-row .notification-background .close-button:active {
    background-color: #${base08};
    color: #${base00};
  }
  
  .control-center {
    box-shadow: 0 0 8px 0 rgba(0, 0, 0, 0.8), inset 0 0 0 1px #${base02};
    border-radius: 12.6px;
    margin: 18px;
    background-color: #${base00};
    color: #${base05};
    padding: 14px;
  }
  
  .control-center .widget-title > label {
    color: #${base05};
    font-size: 1.3em;
  }
  
  .control-center .widget-title button {
    border-radius: 7px;
    color: #${base05};
    background-color: #${base02};
    box-shadow: inset 0 0 0 1px #${base03};
    padding: 8px;
  }
  
  .control-center .widget-title button:hover {
    box-shadow: inset 0 0 0 1px #${base03};
    background-color: #${base04};
    color: #${base05};
  }
  
  .control-center .widget-title button:active {
    box-shadow: inset 0 0 0 1px #${base03};
    background-color: #${base07};
    color: #${base00};
  }
  
  .control-center .notification-row .notification-background {
    border-radius: 7px;
    color: #${base05};
    background-color: #${base02};
    box-shadow: inset 0 0 0 1px #${base03};
    margin-top: 14px;
  }
  
  .control-center .notification-row .notification-background .notification {
    padding: 7px;
    border-radius: 7px;
  }
  
  .control-center .notification-row .notification-background .notification.critical {
    box-shadow: inset 0 0 7px 0 #${base08};
  }
  
  .control-center .notification-row .notification-background .notification .notification-content {
    margin: 7px;
  }
  
  .control-center .notification-row .notification-background .notification .notification-content .summary {
    color: #${base05};
  }
  
  .control-center .notification-row .notification-background .notification .notification-content .time {
    color: #${base05};
  }
  
  .control-center .notification-row .notification-background .notification .notification-content .body {
    color: #${base05};
  }
  
  .control-center .notification-row .notification-background .notification > *:last-child > * {
    min-height: 3.4em;
  }
  
  .control-center .notification-row .notification-background .notification > *:last-child > * .notification-action {
    border-radius: 7px;
    color: #${base05};
    background-color: #${base01};
    box-shadow: inset 0 0 0 1px #${base03};
    margin: 7px;
  }
  
  .control-center .notification-row .notification-background .notification > *:last-child > * .notification-action:hover {
    box-shadow: inset 0 0 0 1px #${base03};
    background-color: #${base02};
    color: #${base05};
  }
  
  .control-center .notification-row .notification-background .notification > *:last-child > * .notification-action:active {
    box-shadow: inset 0 0 0 1px #${base03};
    background-color: #${base07};
    color: #${base05};
  }
  
  .control-center .notification-row .notification-background .close-button {
    margin: 7px;
    padding: 2px;
    border-radius: 6.3px;
    color: #${base00};
    background-color: #${base08};
  }
  
  .close-button {
    border-radius: 6.3px;
  }
  
  .control-center .notification-row .notification-background .close-button:hover {
    background-color: #${base08};
    color: #${base00};
  }
  
  .control-center .notification-row .notification-background .close-button:active {
    background-color: #${base08};
    color: #${base00};
  }
  
  .control-center .notification-row .notification-background:hover {
    box-shadow: inset 0 0 0 1px #${base03};
    background-color: #${base04};
    color: #${base05};
  }
  
  .control-center .notification-row .notification-background:active {
    box-shadow: inset 0 0 0 1px #${base03};
    background-color: #${base07};
    color: #${base05};
  }
  
  .notification.critical progress {
    background-color: #${base08};
  }
  
  .notification.low progress,
  .notification.normal progress {
    background-color: #${base0D};
  }
  
  .control-center-dnd {
    margin-top: 5px;
    border-radius: 8px;
    background: #${base02};
    border: 1px solid #${base03};
    box-shadow: none;
  }
  
  .control-center-dnd:checked {
    background: #${base02};
  }
  
  .control-center-dnd slider {
    background: #${base03};
    border-radius: 8px;
  }
  
  .widget-dnd {
    margin: 0px;
    font-size: 1.1rem;
  }
  
  .widget-dnd > switch {
    font-size: initial;
    border-radius: 8px;
    background: #${base02};
    border: 1px solid #${base03};
    box-shadow: none;
  }
  
  .widget-dnd > switch:checked {
    background: #${base02};
  }
  
  .widget-dnd > switch slider {
    background: #${base03};
    border-radius: 8px;
    border: 1px solid #${base04};
  }
  
  .widget-mpris .widget-mpris-player {
    background: #${base02};
    padding: 7px;
  }
  
  .widget-mpris .widget-mpris-title {
    font-size: 1.2rem;
  }
  
  .widget-mpris .widget-mpris-subtitle {
    font-size: 0.8rem;
  }
  
  .widget-menubar > box > .menu-button-bar > button > label {
    font-size: 3rem;
    padding: 0.5rem 2rem;
  }
  
  .widget-menubar > box > .menu-button-bar > :last-child {
    color: #${base08};
  }
  
  .power-buttons button:hover,
  .powermode-buttons button:hover,
  .screenshot-buttons button:hover {
    background: #${base02};
  }
  
  .control-center .widget-label > label {
    color: #${base05};
    font-size: 2rem;
  }
  
  .widget-buttons-grid {
    padding-top: 1rem;
  }
  
  .widget-buttons-grid > flowbox > flowboxchild > button label {
    font-size: 2.5rem;
  }
  
  .widget-volume {
    padding-top: 1rem;
  }
  
  .widget-volume label {
    font-size: 1.5rem;
    color: #${base07};
  }
  
  .widget-volume trough highlight {
    background: #${base07};
  }
  
  .widget-backlight trough highlight {
    background: #${base0A};
  }
  
  .widget-backlight scale {
    margin-right: 1rem;
  }
  
  .widget-backlight label {
    font-size: 1.5rem;
    color: #${base0A};
  }
  
  .widget-backlight .KB {
    padding-bottom: 1rem;
  }
''
