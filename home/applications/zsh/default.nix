{ pkgs, config, ... }:

{
  programs.zsh = {
    enable = true;
    initExtra = (import ./zsh-syntax-highlighting-base16.nix { inherit pkgs config; });
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      custom = config.home.homeDirectory + "/.zsh/oh-my-zsh";
      plugins = [ "git" "sudo" "colored-man-pages" "themes" ];
      theme = "meoww";
    };
    shellAliases = {
      c = "clear";
      dotdir = "builtin cd ${config.home.homeDirectory}/dotfiles";
      hms = "home-manager switch --flake ${config.home.homeDirectory}/dotfiles";
      nrs = "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/dotfiles";
      nrb = "sudo nixos-rebuild boot --flake ${config.home.homeDirectory}/dotfiles";
      n = builtins.toString (pkgs.writeShellScript "n" ''
        if [[ $# -gt 0 ]] then
          nvim $@
        else
          nvim .
        fi
      '');
    };
  };
  home.file.".zsh/oh-my-zsh" = {
    source = ./oh-my-zsh;
    recursive = true;
  };
}
