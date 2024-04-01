{ userSettings, ... }:

{
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      theme = "catppuccin-${userSettings.catppuccin-flavour}";
      default_layout = "compact";
      pane_frames = false;
      mouse_mode = true;
    };
  };
}
