{ config, ... }:

{
  programs.wlogout = {
    enable = true;
    style = with config.colorScheme.palette; ''
      window {
        background: #${base00};
      }

      button {
        color: #${base0E};
      }
    '';
  };


}
