{ pkgs, config, userSettings, ... }:

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

      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      vim.o.title = true
      vim.o.titlestring = '%t'
      vim.o.guifont = '${userSettings.default-font.name}:h14'

      vim.o.number = true
      vim.o.relativenumber = true
      vim.o.cursorline = true

      vim.o.scrolloff = 8
      vim.o.sidescrolloff = 8
      vim.o.wrap = false

      vim.o.signcolumn = 'yes:1'

      vim.o.ignorecase = true
      vim.o.hlsearch = true

      vim.o.tabstop = 4
      vim.o.shiftwidth = 4
      vim.o.expandtab = true

      vim.o.list = true
      vim.o.listchars='tab:«-»,trail:·,nbsp:␣,extends:⟩,precedes:⟨'

      vim.o.termguicolors = true

      vim.o.mouse = 'a'
      vim.o.mousemoveevent = true
      vim.o.mousemodel = 'extend'

      vim.o.conceallevel = 1
      vim.o.concealcursor = 'cnv'

      vim.o.clipboard = 'unnamedplus'

      vim.o.showmode = false
      vim.o.ruler = false

      vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
      vim.o.foldtext = 'nvim_treesitter#foldtext()'
      vim.o.foldmethod = 'expr'
      vim.o.foldenable = false

      vim.o.completeopt = 'menuone,preview,noselect,fuzzy,nosort'
    '';

    extraConfig = /* vim */ ''
      augroup CursorLine
        au!
        au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
        au WinLeave * setlocal nocursorline
      augroup END

      inoremap <Up> <C-O>gk
      inoremap <Down> <C-O>gj

      inoremap <C-ö> :tabprevious<CR>
      inoremap <C-ä> :tabnext<CR>

      if exists("g:neovide")
        let g:neovide_cursor_animation_length = 0.05
        let g:neovide_cursor_trail_size = 0
        let g:neovide_cursor_animate_in_insert_mode = v:false
        let g:neovide_cursor_animate_command_line = v:false
        let g:neovide_hide_mouse_when_typing = 1
      else
        " autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE
        " autocmd vimenter * hi NormalNC guibg=NONE ctermbg=NONE
        " autocmd vimenter * hi LineNr guibg=NONE ctermbg=NONE
        " autocmd vimenter * hi CursorLine guibg=NONE ctermbg=NONE
        " autocmd vimenter * hi CursorLineNr guibg=NONE ctermbg=NONE
        " autocmd vimenter * hi CursorLineSign guibg=NONE ctermbg=NONE
        hi Normal guibg=NONE ctermbg=NONE
        hi NormalNC guibg=NONE ctermbg=NONE
        hi LineNr guibg=NONE ctermbg=NONE
        " hi CursorLine guibg=NONE ctermbg=NONE
        " hi CursorLineNr guibg=NONE ctermbg=NONE
        " hi CursorLineSign guibg=NONE ctermbg=NONE
      endif
    '';

    plugins = with pkgs.vimPlugins; [
      battery-nvim
      cmp-buffer
      cmp-cmdline
      # cmp_luasnip
      cmp-async-path
      cmp-nvim-lsp
      cmp-nvim-lsp-document-symbol
      cmp-nvim-lsp-signature-help
      isabelle-syn-nvim
      markdown-preview-nvim
      nvim-web-devicons
      telescope-tabs
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
        plugin = copilot-vim;
        type = "viml";
        config = ''
          imap <silent><script><expr> <C-Tab> copilot#Accept("\<CR>")
          let g:copilot_no_tab_map = v:true
        '';
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
        plugin = indent-blankline-nvim-lua;
        type = "lua";
        config = ''require("ibl").setup { scope = { show_start = false, show_end = false }, indent = { priority = 0, }, }'';
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

      # {
      #   plugin = luasnip;
      #   type = "lua";
      #   config = builtins.readFile ./luasnip.lua;
      # }

      {
        plugin = nvim-cmp;
        type = "lua";
        config = builtins.readFile ./nvim-cmp.lua;
      }

      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile ./nvim-lspconfig.lua;
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
        type = "viml";
        config = '' let g:vimtex_general_viewer = '${config.home.shellAliases.xopen}' '';
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
      typescript-language-server
      vscode-langservers-extracted

      # Misc
      acpi
      fd
      nodePackages.nodejs
      ripgrep
    ];
  };  
}
