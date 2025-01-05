{ config, ... }:

{
  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      theme = "${config.colorScheme.slug}";
      default_layout = "compact";
      pane_frames = false;
      mouse_mode = true;
    };
  };
}
