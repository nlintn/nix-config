{ pkgs, config, ... }:

{
  programs.neovide = {
    enable = true;
    settings = {};
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraLuaConfig = /* lua */ ''
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ' '

      vim.o.number = true
      vim.o.relativenumber = true
      vim.o.cursorline = true

      vim.o.scrolloff = 5
      vim.o.wrap = false

      vim.o.signcolumn = 'yes:1'

      vim.o.ignorecase = true

      vim.o.tabstop = 4
      vim.o.shiftwidth = 4
      vim.o.expandtab = true

      vim.o.list = true
      vim.o.listchars='tab:«-»,space:·,nbsp:␣,extends:⟩,precedes:⟨'

      vim.o.termguicolors = true

      vim.o.mouse = 'a'
      vim.o.mousemoveevent = true
      vim.o.mousemodel = 'extend'

      vim.o.conceallevel = 1
      vim.o.concealcursor = 'cnv'

      vim.o.clipboard = 'unnamedplus'

      vim.o.showmode = false

      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    '';

    extraConfig = /* vim */ ''
      map gn :e <cfile><CR>

      augroup CursorLine
        au!
        au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
        au WinLeave * setlocal nocursorline
      augroup END
      
      inoremap <Up> <C-O>gk
      inoremap <Down> <C-O>gj

      noremap <C-ö> :tabprevious<CR>
      noremap <C-ä> :tabnext<CR>

      if exists("g:neovide")
        let g:neovide_cursor_animation_length = 0.05
        let g:neovide_cursor_trail_size = 0
        let g:neovide_cursor_animate_in_insert_mode = v:false
        let g:neovide_cursor_animate_command_line = v:false
        let g:neovide_hide_mouse_when_typing = 1
      else
        autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE
        autocmd vimenter * hi NormalNC guibg=NONE ctermbg=NONE
        autocmd vimenter * hi LineNr guibg=NONE ctermbg=NONE
        autocmd vimenter * hi CursorLine guibg=NONE ctermbg=NONE
        autocmd vimenter * hi CursorLineNr guibg=NONE ctermbg=NONE
        autocmd vimenter * hi CursorLineSign guibg=NONE ctermbg=NONE
      endif
    '';

    plugins = with pkgs.vimPlugins; [
      (pkgs.callPackage ./battery-nvim.nix {})
      cmp_luasnip
      cmp-nvim-lsp
      copilot-vim
      (import ./isabelle-syn-nvim.nix { inherit pkgs; }).package
      markdown-preview-nvim
      neodev-nvim
      nvim-web-devicons
      playground
      telescope-file-browser-nvim
      (pkgs.callPackage ./telescope-tabs.nix {})
      telescope-ui-select-nvim
      vim-wakatime

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
        plugin = crates-nvim;
        type = "lua";
        config = builtins.readFile ./crates-nvim.lua;
      }

      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = builtins.readFile ./gitsigns-nvim.lua;
      }

      {
        plugin = guess-indent-nvim;
        type = "lua";
        config = ''require("guess-indent").setup {}'';
      }

      {
        plugin = (pkgs.callPackage ./isabelle-lsp-nvim.nix {}).package;
        type = "lua";
        config = (pkgs.callPackage ./isabelle-lsp-nvim.nix {}).config;
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
      nixd
      pyright
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
