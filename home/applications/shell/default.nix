{ pkgs, config, ... }:

let  
  shellAliases = {
    c = "clear";
    dotdir = "builtin cd ${config.home.homeDirectory}/dotfiles";
    hms = "home-manager switch --flake ${config.home.homeDirectory}/dotfiles";
    nrs = "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/dotfiles";
    nrb = "sudo nixos-rebuild boot --flake ${config.home.homeDirectory}/dotfiles";
    n = builtins.toString (pkgs.writeShellScript "n" ''
      if [[ $# -gt 0 ]] then
        ${config.programs.neovim.finalPackage}/bin/nvim $@
      else
        ${config.programs.neovim.finalPackage}/bin/nvim .
      fi
    '');
  };
in {
  programs.zsh = {
    enable = true;
    initExtra = (import ./zsh-syntax-highlighting-base16.nix { inherit pkgs config; });
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      custom = builtins.path { name = "oh-my-zsh-custom"; path = ./oh-my-zsh-custom; recursive = true; };
      plugins = [ "git" "sudo" "colored-man-pages" "themes" ];
      theme = "meoww";
    };
    inherit shellAliases;
  };

  programs.bash = {
    enable = true;
    inherit shellAliases;
  };
}

