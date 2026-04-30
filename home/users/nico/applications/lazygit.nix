{
  ...
}:

{
  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        autoFetch = false;
        overrideGpg = true;
      };
      gui = {
        timeFormat = "2006/01/02";
        showNumstatInFilesView = true;
      };
      update.method = "never";
    };
  };
}
