{ inputs, userSettings, ... }:

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
      custom = builtins.toString ./oh-my-zsh;
      plugins = [ "git" "sudo" "colored-man-pages" "per-directory-history" "themes" ];
      theme = "meoww";
    };
    shellAliases = {
      c = "clear";
      dotdir = "builtin cd $DOT_DIR";
      hms = "home-manager switch --flake $DOT_DIR";
      nrs = "sudo nixos-rebuild switch --flake $DOT_DIR";
      nrb = "sudo nixos-rebuild boot --flake $DOT_DIR";
    };
    # cdpath = [ "HOME/dotfiles" "$HOME/TUM" ];
    # Opam env
    # initExtra = ''
    #   [[ ! -r /home/nico/.opam/opam-init/init.zsh ]] || source /home/nico/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
    # '';
  };
}
