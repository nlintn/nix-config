{ pkgs, ... }:

{
  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird-latest;
    profiles.nico = {
      isDefault = true;
      settings = {
        "mail.server.default.check_all_folders_for_new" = true;
        "mailnews.default_news_sort_order" = 2;
        "mailnews.default_sort_order" = 2;
        "mailnews.default_news_sort_type" = 35;
        "mailnews.default_sort_type" = 35;
        "mailnews.default_news_view_flags" = 1;
        "mailnews.default_view_flags" = 1;
        "mailnews.start_page.url" = "https://lintn.de";
        "browser.display.use_system_colors" = true;
      };
    };
  };
}
