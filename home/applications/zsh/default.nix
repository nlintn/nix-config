{ pkgs, config, inputs, userSettings, ... }:

{
  programs.zsh = {
    enable = true;
    plugins = [
      {
        name = "syntax-highlighting_catppuccin";
        file = "themes/catppuccin_${userSettings.catppuccin-flavour}-zsh-syntax-highlighting.zsh";
        src = inputs.catppuccin-zsh-syntax-highlighting;
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = inputs.zsh-nix-shell;
      }
    ];
    enableAutosuggestions = true;
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
          ${config.programs.neovim.package}/bin/nvim $@
        else
          ${config.programs.neovim.package}/bin/nvim .
        fi
      '');
    };
    # cdpath = [ "HOME/dotfiles" "$HOME/TUM" ];
    # Opam env
    # initExtra = ''
    #   [[ ! -r /home/nico/.opam/opam-init/init.zsh ]] || source /home/nico/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
    # '';
  };
  home.file.".zsh/oh-my-zsh" = {
    source = ./oh-my-zsh;
    recursive = true;
  };
}
