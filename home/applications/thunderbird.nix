{ ... }:

{
  programs.thunderbird = {
    enable = true;
    profiles.nico = {
      isDefault = true;
      settings = {
        "mailnews.default_news_sort_order" = 2;
        "mailnews.default_sort_order" = 2;
        "mailnews.default_news_sort_type" = 27;
        "mailnews.default_sort_type" = 27;
        "mailnews.start_page.url" = "https://lintn.de";
        "browser.display.use_system_colors" = true;
      };
    };
  };
}
