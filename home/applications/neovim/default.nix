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
    '';

    plugins = with pkgs.vimPlugins; [
      cmp_luasnip
      cmp-nvim-lsp
      luasnip
      neodev-nvim
      markdown-preview-nvim
      nvim-web-devicons

      {
        plugin = base16-nvim;
        type = "lua";
        config = import ./base16-nvim.nix { inherit config; };
      }

      {
        plugin = comment-nvim;
        type = "lua";
        config = ''require("Comment").setup {}'';
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
        plugin = (nvim-treesitter.withPlugins (p: [
          p.tree-sitter-bash
          p.tree-sitter-c
          p.tree-sitter-cpp
          p.tree-sitter-json
          p.tree-sitter-lua
          p.tree-sitter-nix
          p.tree-sitter-ocaml
          p.tree-sitter-python
          p.tree-sitter-rust
          p.tree-sitter-vim
        ]));
        type = "lua";
        config = builtins.readFile ./nvim-treesitter.lua;
      }
      
      {
        plugin = nvim-autopairs;
        type = "lua";
        config = ''require("nvim-autopairs").setup {}'';
      }
      
      {
        plugin = rainbow-delimiters-nvim;
        type = "lua";
        config = ''require("rainbow-delimiters.setup").setup {}'';
      }

      {
        plugin = telescope-nvim;
        type = "lua";
        config = builtins.readFile ./telescope-nvim.lua;
      }
    ];

    extraPackages = with pkgs; [
      fd
      lua-language-server
      nil
      ripgrep
      rust-analyzer
    ];
  };  
}
