{ fetchFromGitHub, lua51Packages, neovimUtils, writeText }:

{
  package = neovimUtils.buildNeovimPlugin {
    luaAttr = lua51Packages.buildLuarocksPackage {
      pname = "isabelle-lsp.nvim";
      version = "scm-1";
      src = fetchFromGitHub {
        owner = "Treeniks";
        repo = "isabelle-lsp.nvim";
        rev = "8eaf60f08d7f3ec6782d12327fa7e1b88545bd7c";
        sha256 = "sha256-rtwhEB8Aq+2RbS4ZtydKmodwfk2N6LE5GIBdfu8Ru04=";
      };
      disabled = lua51Packages.lua.luaversion != "5.1";
      knownRockspec = writeText "isabelle-lsp.nvim-scm-1.rockspec" ''
        package = "isabelle-lsp.nvim"
        version = "scm-1"
        source = {
          url = "git://github.com/Treeniks/isabelle-lsp.nvim",
        }
        dependencies = {
          "lua == 5.1",
        }
        build = {
          type = "builtin",
          modules = {
            ["isabelle-lsp"] = "lua/isabelle-lsp.lua",
          },
        }
      '';
    };
    nvimRequiredCheck = "isabelle-lsp";
  };
  config = /* lua */ ''
    require("isabelle-lsp").setup {
      isabelle_path = os.getenv("LOCAL_ISABELLE_PATH") or "isabelle",
      log = nil,
      verbose = false,
      unicode_symbols_output = true,
      unicode_symbols_edits = true,
      hl_group_map = {
        ['background_unprocessed1'] = false,
        ['background_running1'] = false,
        ['background_canceled'] = false,
        ['background_bad'] = false,
        ['background_intensify'] = false,
        ['background_markdown_bullet1'] = 'markdownH1',
        ['background_markdown_bullet2'] = 'markdownH2',
        ['background_markdown_bullet3'] = 'markdownH3',
        ['background_markdown_bullet4'] = 'markdownH4',
        ['foreground_quoted'] = false,
        ['text_main'] = false,
        ['text_quasi_keyword'] = 'Keyword',
        ['text_free'] = 'Function',
        ['text_bound'] = 'Character',
        ['text_inner_numeral'] = false,
        ['text_inner_quoted'] = 'String',
        ['text_comment1'] = 'Comment',
        ['text_comment2'] = false, -- seems to not exist in the LSP
        ['text_comment3'] = false,
        ['text_dynamic'] = false,
        ['text_class_parameter'] = false,
        ['text_antiquote'] = 'Comment',
        ['text_raw_text'] = 'Comment',
        ['text_plain_text'] = 'String',
        ['text_overview_unprocessed'] = false,
        ['text_overview_running'] = 'Todo',
        ['text_overview_error'] = false,
        ['text_overview_warning'] = false,
        ['dotted_writeln'] = false,
        ['dotted_warning'] = "DiagnosticUnderlineWarn",
        ['dotted_information'] = false,
        ['spell_checker'] = 'Underlined',
        ['text_inner_cartouche'] = false,
        ['text_var'] = 'Function',
        ['text_skolem'] = 'Boolean',
        ['text_tvar'] = 'Type',
        ['text_tfree'] = 'Type',
        ['text_operator'] = 'Type',
        ['text_improper'] = 'Macro',
        ['text_keyword3'] = 'Keyword',
        ['text_keyword2'] = 'Operator',
        ['text_keyword1'] = 'Keyword',
        ['foreground_antiquoted'] = false,
      }
    }
  '';
}
