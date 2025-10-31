{ userSettings, ... } @ args:

{
  programs.ghostty = {
    enable = true;
    themes.base16 = import ./base16.nix args;
    settings = {
      auto-update = "off";
      theme = "base16";
      window-theme = "ghostty";
      app-notifications = false;

      background-opacity = 0.7;

      font-family = userSettings.default-font.name;
      font-size = 10.5;

      shell-integration-features = "ssh-env, sudo, title";
    };
  };
}
