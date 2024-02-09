{ ... }:

{
  programs.feh = {
    enable = true;
    buttons = {
      zoom_in = "C-4";
      zoom_out = "C-5";
      scroll_up = "4";
      scroll_down = "5";
      scroll_left = "6";
      scroll_right = "7";
      prev_img = null;
      next_img = null;
    };
    keybindings = {
      prev_img = "Left";
      next_img = "Right";
    };
  };
}