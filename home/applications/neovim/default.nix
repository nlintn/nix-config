{ pkgs, config, ... }:

{
  programs.neovim = {
    enable = true;

    extraLuaConfig = ''
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ' '

      vim.o.number = true
      vim.o.relativenumber = true

      vim.o.signcolumn = 'number'

      vim.o.tabstop = 4
      vim.o.shiftwidth = 4
      vim.o.expandtab = true

      vim.o.termguicolors = true

      vim.o.mouse = 'a'
      vim.o.mousemoveevent = true
    '';

    extraConfig = ''
      set whichwrap+=<,>,h,l,[,]
      autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE
      autocmd vimenter * hi NormalNC guibg=NONE ctermbg=NONE
    '';

    plugins = with pkgs.vimPlugins; [
      cmp_luasnip
      cmp-nvim-lsp
      luasnip
      neodev-nvim
      markdown-preview-nvim
      nvim-web-devicons
      playground

      {
        plugin = import ./base16-nvim/package-patched.nix { inherit pkgs; };
        type = "lua";
        config = import ./base16-nvim/lua-config.nix { inherit config; };
      }

      {
        plugin = comment-nvim;
        type = "lua";
        config = ''require("Comment").setup {}'';
      }

      {
        plugin = copilot-lua;
        type = "lua";
        config = ''require("copilot").setup {}'';
      }

      {
        plugin = guess-indent-nvim;
        type = "lua";
        config = ''require("guess-indent").setup {}'';
      }

      {
        plugin = lsp-zero-nvim;
        type = "lua";
        config = builtins.readFile ./lsp-zero-nvim.lua;
      }

      {
        plugin = nvim-cmp;
	      type = "lua";
        config = builtins.readFile ./nvim-cmp.lua;
      }

      {
        plugin = nvim-lspconfig;
        # type = "lua";
        # config = builtins.readFile ./nvim-lspconfig.lua;
      }

      {
        plugin = nvim-navic;
        type = "lua";
        config = builtins.readFile ./nvim-navic.lua;
      }

      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = builtins.readFile ./nvim-tree-lua.lua;
      }
      
      {
        plugin = import ./nvim-treesitter/package-withPlugins.nix { inherit pkgs; };
        type = "lua";
        config = builtins.readFile ./nvim-treesitter/lua-config.lua;
      }
      
      {
        plugin = nvim-autopairs;
        type = "lua";
        config = ''require("nvim-autopairs").setup {}'';
      }

      {
        plugin = rainbow-delimiters-nvim;
        type = "lua";
        config = builtins.readFile ./rainbow-delimiters-nvim.lua;
      }

      {
        plugin = telescope-nvim;
        type = "lua";
        config = builtins.readFile ./telescope-nvim.lua;
      }

      {
        plugin = vimtex;
      }
    ];

    extraPackages = with pkgs; [
      fd
      jdt-language-server
      lua-language-server
      nil
      nodePackages.nodejs
      ripgrep
      rust-analyzer
    ];
  };  
}
