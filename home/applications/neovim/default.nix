{ pkgs, config, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    extraLuaConfig = /* lua */ ''
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ' '

      vim.o.number = true
      vim.o.relativenumber = true

      vim.o.signcolumn = 'yes:1'

      vim.o.ignorecase = true
      vim.keymap.set("n", "<leader>/", ":noh<CR>", { silent = true })

      vim.o.tabstop = 4
      vim.o.shiftwidth = 4
      vim.o.expandtab = true

      vim.o.termguicolors = true

      vim.o.mouse = 'a'
      vim.o.mousemoveevent = true

      vim.o.conceallevel = 1
      vim.o.concealcursor = 'cnv'

      vim.o.clipboard = 'unnamedplus'

      vim.o.showmode = false

      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    '';

    extraConfig = /* vim */ ''
      set whichwrap+=<,>,h,l,[,]
      autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE
      autocmd vimenter * hi NormalNC guibg=NONE ctermbg=NONE
      autocmd vimenter * hi LineNr guibg=NONE ctermbg=NONE
    '';

    plugins = with pkgs.vimPlugins; [
      (import ./battery-nvim.nix { inherit pkgs; }).package
      cmp-fuzzy-path
      cmp_luasnip
      cmp-nvim-lsp
      (import ./isabelle-syn-nvim.nix { inherit pkgs; }).package
      markdown-preview-nvim
      neodev-nvim
      nvim-web-devicons
      playground
      telescope-file-browser-nvim

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

      /* {
        plugin = copilot-lua;
        type = "lua";
        config = ''require("copilot").setup {}'';
      } */

      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''require("gitsigns").setup {}'';
      }

      {
        plugin = guess-indent-nvim;
        type = "lua";
        config = ''require("guess-indent").setup {}'';
      }

      {
        plugin = (import ./isabelle-lsp-nvim/package-config.nix { inherit pkgs; }).package;
        type = "lua";
        config = (import ./isabelle-lsp-nvim/package-config.nix { inherit pkgs; }).config;
      }

      {
        plugin = lualine-nvim;
        type = "lua";
        config = import ./lualine-nvim.nix { inherit config; };
      }

      {
        plugin = luasnip;
        type = "lua";
        config = builtins.readFile ./luasnip.lua;
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
        plugin = obsidian-nvim;
        type = "lua";
        config = builtins.readFile ./obsidian-nvim.lua;
      }

      {
        plugin = oil-nvim;
        type = "lua";
        config = builtins.readFile ./oil-nvim.lua;
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
      # Language Servers
      clang-tools_17
      jdt-language-server
      lua-language-server
      nil
      nodePackages.pyright
      ocamlPackages.ocaml-lsp
      rust-analyzer
      texlab

      # Misc
      acpi
      fd
      nodePackages.nodejs
      ripgrep
    ];
  };  
}
