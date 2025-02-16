{ pkgs, lib, config, ... }:

let  
  shellAliases = {
    c = "${pkgs.ncurses}/bin/clear";
    cat = lib.mkIf config.programs.bat.enable "${pkgs.bat}/bin/bat";
    confdir = "builtin cd ${config.home.sessionVariables.NIX_CONFIG_DIR}";
    hms = "home-manager switch --flake $NIX_CONFIG_DIR";
    nrs = "nixos-rebuild switch --flake $NIX_CONFIG_DIR --use-remote-sudo";
    nrb = "nixos-rebuild boot --flake $NIX_CONFIG_DIR --use-remote-sudo";
    open = "${pkgs.xdg-utils}/bin/xdg-open";
    xopen = "${(pkgs.writeShellScript "xopen" /* bash */ ''
      ${pkgs.xdg-utils}/bin/xdg-open "$*" > /dev/null 2>&1 & disown
    '')}";
  };
in {
  programs.zsh = {
    enable = true;
    initExtra = (import ./zsh-syntax-highlighting-base16.nix { inherit config; }) + /* bash */ ''
      bindkey -v
      bindkey -M vicmd 'V' edit-command-line
      VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
      VI_MODE_SET_CURSOR=true
      KEYTIMEOUT=1
    '';
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      custom = builtins.path { name = "oh-my-zsh-custom"; path = ./oh-my-zsh-custom; recursive = true; };
      plugins = [ "colored-man-pages" "git" "themes" "vi-mode" ];
      theme = "meoww_lambda";
    };
    inherit shellAliases;
  };

  programs.bash = {
    enable = true;
    inherit shellAliases;
  };
}

