{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.nautilus = {
    enable = true;
    extensions = [
      pkgs.nautilus-open-any-terminal
    ];
  };

  dconf.settings = {
    "org/gnome/nautilus" = {
      "compression/default-compression-format" = "tar.xz";
      "icon-view/captions" = [
        "size"
        "date_modified"
        "none"
      ];
      "list-view/default-visible-columns" = [
        "name"
        "size"
        "type"
        "owner"
        "group"
        "permissions"
        "date_modified"
      ];
      "list-view/use-tree-view" = true;
      "preferences/date-time-format" = "detailed";
      "preferences/migrated-gtk-settings" = true;
      "preferences/show-create-link" = true;
    };

    "com/github/stunkymonkey/nautilus-open-any-terminal" = {
      "terminal" = "custom";
      "custom-local-command" =
        config.vars.launchPrefix + "${lib.getExe config.xdg.terminal-exec.package} --dir=%s"
        |> lib.hm.gvariant.mkString;
    };
  };
}
