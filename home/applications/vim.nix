{ pkgs, userSettings, ... }:

{
  programs.vim = {
    enable = true;
    defaultEditor = true;
    settings = {
      number = true;
      relativenumber = true;
      mouse = "a";
      expandtab = true;
      tabstop = 4;
      shiftwidth = 4;
    };
    plugins = with pkgs.vimPlugins; [
      catppuccin-vim
    ];
    extraConfig = ''
      set termguicolors
      colorscheme catppuccin_${userSettings.catppuccin-flavour}
      autocmd vimenter * hi Normal guibg=NONE
      if $XTERM == 'xterm-256color'
        set ttymouse=sgr
      endif
    ''; 
  };
}

