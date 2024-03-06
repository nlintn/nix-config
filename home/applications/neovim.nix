{ pkgs, userSettings, ... }:

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
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          local builtin = require('telescope.builtin')
          vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        '';
      }
      {
        plugin = catppuccin-nvim;
        config = "colorscheme catppuccin-${userSettings.catppuccin-flavour}";
      }
      {
        plugin = comment-nvim;
        type = "lua";
        config = ''
          require("Comment").setup()
        '';
      }
      {
        plugin = nvim-cmp;
	    type = "lua";
        config = builtins.readFile ./neovim/cmp.lua;
      }
      {
        plugin = nvim-lspconfig;
        # type = "lua";
        # config = builtins.readFile ./neovim/lsp.lua;
      }
      {
        plugin = lsp-zero-nvim;
        type = "lua";
        config = ''
          require("lsp-zero")
	        local lsp_zero = require('lsp-zero')

	        lsp_zero.on_attach(function(client, bufnr)
  	        lsp_zero.default_keymaps({buffer = bufnr})
	        end)
          require("lspconfig").clangd.setup {}
          require("lspconfig").nil_ls.setup {}
          require("lspconfig").lua_ls.setup {}
          require("lspconfig").rust_analyzer.setup {}
        '';
      }
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
          require("nvim-tree").setup()
        '';
      }
      cmp_luasnip
      cmp-nvim-lsp
      luasnip
      neodev-nvim
      nvim-web-devicons
      {
        plugin = nvim-navic;
        type = "lua";
        config = ''
          local navic = require("nvim-navic")
          navic.setup {
            lsp = { auto_attach = true, },
          }
        '';
      }
      {
        plugin = (nvim-treesitter.withPlugins (p: [
          p.tree-sitter-c
          p.tree-sitter-cpp
          p.tree-sitter-nix
          p.tree-sitter-vim
          p.tree-sitter-bash
          p.tree-sitter-lua
          p.tree-sitter-python
          p.tree-sitter-json 
        ]));
        type = "lua";
        config = ''
          require("nvim-treesitter.configs").setup {
            ensure_installed = {},
            auto_install = false,
            highlight = { enable = true },
            indent = { enable = true },
          };

        '';
      }
      {
        plugin = guess-indent-nvim;
        type = "lua";
        config = ''
          require("guess-indent").setup {}
        '';
      }
      {
        plugin = nvim-autopairs;
        type = "lua";
        config = ''
          require("nvim-autopairs").setup {}
        '';
      }
      {
        plugin = rainbow-delimiters-nvim;
        type = "lua";
        config = ''
          require("rainbow-delimiters.setup").setup {}
        '';
      }
    ];

    extraPackages = with pkgs; [
      fd
      ripgrep
      nil
      lua-language-server
      rust-analyzer
    ];
  };  
}
