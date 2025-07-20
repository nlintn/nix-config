{ pkgs, lib, config,  ... }:

{
  home.shellAliases = rec {
    c = "${pkgs.ncurses}/bin/clear";
    cat = lib.mkIf config.programs.bat.enable "${config.programs.bat.package}/bin/bat --paging=never";
    confdir = "builtin cd -- ${config.home.configDirectory}";
    open = "${pkgs.xdg-utils}/bin/xdg-open";
    xopen = "${(pkgs.writeShellScript "xopen" /* sh */ ''
      export TMPSTDOUT=$(mktemp -t xopen.XXXXXX)
      export TMPSTDERR=$(mktemp -t xopen.XXXXXX)
      ${config.programs.kitty.package}/bin/kitty --class xopen --detach --hold ${pkgs.writeShellScript "_xopen" "${open} $* > $TMPSTDOUT 2> $TMPSTDERR"}
      cat $TMPSTDOUT
      cat $TMPSTDERR >&2
      rm $TMPSTDOUT $TMPSTDERR
    '')}";
    lt = "ls -ltr";
  } // lib.optionalAttrs ((! config.submoduleSupport.enable) && config.programs.home-manager.enable) {
    hms = "home-manager switch --flake ${config.home.configDirectory}";
  } // lib.optionalAttrs (config.nix.enable && config.submoduleSupport.enable) {
    nrs = "nixos-rebuild switch --flake ${config.home.configDirectory} --sudo";
    nrb = "nixos-rebuild boot --flake ${config.home.configDirectory} --sudo";
  } // lib.optionalAttrs config.nix.enable {
    ns = "nix shell";
    nr = "nix run";
  };

  programs.zsh = {
    enable = true;
    initContent = (import ./zsh-syntax-highlighting-base16.nix { inherit config; }) + /* bash */ ''
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
      custom = builtins.path { path = ./oh-my-zsh-custom; recursive = true; };
      plugins = [ "colored-man-pages" "git" "themes" "vi-mode" ];
      theme = "meoww_lambda";
    };
  };
  programs.bash.enable = true;
}

