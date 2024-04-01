{ pkgs }:

pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
  p.tree-sitter-bash
  p.tree-sitter-c
  p.tree-sitter-cpp
  p.tree-sitter-java
  p.tree-sitter-json
  p.tree-sitter-lua
  p.tree-sitter-markdown
  p.tree-sitter-markdown_inline
  p.tree-sitter-nix
  p.tree-sitter-ocaml
  p.tree-sitter-python
  p.tree-sitter-rust
  p.tree-sitter-vim
])
