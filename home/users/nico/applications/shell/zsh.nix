{ config, lib, pkgs, ... } @ args:

{
  programs.zsh = {
    enable = true;
    initContent = lib.mkMerge [
      (lib.mkOrder 810 (builtins.readFile ./vi-mode.zsh))
      (import ./zsh-syntax-highlighting-base16.nix args)
      /* sh */ ''
        KEYTIMEOUT=1

        function man {
          ${pkgs.coreutils}/bin/env \
            LESS_TERMCAP_mb="''${fg_bold[red]}" \
            LESS_TERMCAP_md="''${fg_bold[red]}" \
            LESS_TERMCAP_me="''${reset_color}" \
            LESS_TERMCAP_us="''${fg_bold[green]}" \
            LESS_TERMCAP_ue="''${reset_color}" \
            LESS_TERMCAP_so="''${fg_bold[black]}''${bg[magenta]}" \
            LESS_TERMCAP_se="''${reset_color}" \
            GROFF_NO_SGR=1 \
            ${config.programs.man.package}/bin/man $@
        }
      ''
    ];
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      custom = builtins.path { path = ./oh-my-zsh-custom; recursive = true; };
      plugins = [ "themes" ];
      theme = "meoww_lambda";
    };
  };
}
