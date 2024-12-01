{ pkgs }:

let
  isabelle = pkgs.isabelle2024-nvim-lsp;
in {
  package = pkgs.vimUtils.buildVimPlugin {
    name = "isabelle-lsp.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "Treeniks";
      repo = "isabelle-lsp.nvim";
      rev = "206cca02a9b95925f362cea35b1fba2a24dff37b";
      sha256 = "sha256-mbiUvthEQHQvmNGZtFccasiQ0ksFP0XpZzzK79m14UU=";
    };
    patches = [ ./disable-logging.patch ];
  };
  config = /* lua */ ''
    require("isabelle-lsp").setup {
      -- isabelle_path = "${isabelle}/bin/isabelle",
      isabelle_path = "isabelle/bin/isabelle",
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
        ['text_main'] = 'Normal',
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
