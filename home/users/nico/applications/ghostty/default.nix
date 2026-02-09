{ userSettings, ... }@args:

{
  programs.ghostty = {
    enable = true;
    themes.base16 = import ./base16.nix args;
    clearDefaultKeybinds = true;
    settings = {
      auto-update = "off";
      app-notifications = false;

      adjust-cursor-thickness = "100%";
      background-opacity = 0.65;
      font-family = userSettings.default-font.name;
      font-feature = [
        "-calt"
        "-liga"
        "-dlig"
      ];
      font-size = 10;
      mouse-hide-while-typing = true;
      theme = "base16";
      window-theme = "ghostty";

      window-inherit-working-directory = false;
      window-inherit-font-size = true;

      copy-on-select = "clipboard";
      shell-integration-features = "ssh-env, sudo, title, no-cursor";

      keybind = [
        "ctrl+shift+a=select_all"
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+i=inspector:toggle"
        "ctrl+shift+n=new_window"
        "ctrl+shift+p=toggle_command_palette"
        "ctrl+shift+page_down=jump_to_prompt:1"
        "ctrl+shift+page_up=jump_to_prompt:-1"
        "ctrl+shift+q=quit"
        "ctrl+shift+r=reload_config"
        "ctrl+shift+v=paste_from_clipboard"

        "ctrl+shift+t=new_tab"
        "ctrl+shift+w=close_tab:this"
        "ctrl+shift+arrow_left=previous_tab"
        "ctrl+shift+arrow_right=next_tab"

        "ctrl+shift++=increase_font_size:1"
        "ctrl+shift+-=decrease_font_size:1"
        "ctrl+shift+0=reset_font_size"
      ];
    };
  };
}
