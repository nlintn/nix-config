{ inputs, userSettings, ... }:

let 
  custom_dir = ".oh-my-custom";
in {
  home.file.${custom_dir + "/themes/meoww.zsh-theme"}.source = ./meoww.zsh-theme;

  programs.zsh = {
    enable = true;
    plugins = [
      {
        name = "syntax-highlighting_catppuccin";
        file = "themes/catppuccin_${userSettings.catppuccin-flavour}-zsh-syntax-highlighting.zsh";
        src = inputs.catppuccin-zsh-syntax-highlighting;
      }
    ];
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      custom = "$HOME/" + custom_dir;
      plugins = [ "git" "sudo" "colored-man-pages" "copyfile" "copypath" "per-directory-history" "themes"];
      theme = "meoww";
    };
    shellAliases = {
      c = "clear";
    };
    # Opam env
    # initExtra = ''
    #   [[ ! -r /home/nico/.opam/opam-init/init.zsh ]] || source /home/nico/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
    # '';
  };
}