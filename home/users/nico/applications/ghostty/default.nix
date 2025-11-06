{ userSettings, ... } @ args:

{
  programs.ghostty = {
    enable = true;
    themes.base16 = import ./base16.nix args;
    settings = {
      auto-update = "off";
      app-notifications = false;
      working-directory = "home";

      adjust-cursor-thickness = "100%";
      background-opacity = 0.65;
      font-family = userSettings.default-font.name;
      font-feature = [ "-calt" "-liga" "-dlig" ];
      font-size = 11;
      mouse-hide-while-typing = true;
      theme = "base16";
      window-theme = "ghostty";

      window-inherit-working-directory = false;
      window-inherit-font-size = true;

      shell-integration-features = "ssh-env, sudo, title, no-cursor";
    };
  };
}
