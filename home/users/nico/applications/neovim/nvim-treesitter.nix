{ vimPlugins }:

{
  pkg = vimPlugins.nvim-treesitter.withPlugins (p: [
    p.tree-sitter-bash
    p.tree-sitter-c
    p.tree-sitter-c_sharp
    p.tree-sitter-cmake
    p.tree-sitter-cpp
    p.tree-sitter-css
    p.tree-sitter-csv
    p.tree-sitter-html
    p.tree-sitter-htmldjango
    p.tree-sitter-java
    p.tree-sitter-javascript
    p.tree-sitter-json
    p.tree-sitter-latex
    p.tree-sitter-lua
    p.tree-sitter-make
    p.tree-sitter-markdown
    p.tree-sitter-markdown_inline
    p.tree-sitter-nix
    p.tree-sitter-ocaml
    p.tree-sitter-python
    p.tree-sitter-rust
    p.tree-sitter-sql
    p.tree-sitter-vim
    p.tree-sitter-xml
    p.tree-sitter-yaml
    p.tree-sitter-zig
  ]);

  config = /* lua */ ''
    require("nvim-treesitter.configs").setup {
      ensure_installed = {},
      auto_install = false,
      highlight = { enable = true },
      indent = { enable = false },
    };
  '';
}
