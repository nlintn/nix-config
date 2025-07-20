{ config, lib, userSettings,  ... }:

{
  options = {
    home.configDirectory = lib.mkOption {
      type = lib.types.path;
      default = "${config.home.homeDirectory}/${userSettings.rel-config-path}";
    };
  };
}
