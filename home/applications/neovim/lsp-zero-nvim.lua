require("lsp-zero")
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(
  function(client, bufnr)
    lsp_zero.default_keymaps({buffer = bufnr})
  end)

require("lspconfig").clangd.setup {}
require("lspconfig").nil_ls.setup {}
require("lspconfig").lua_ls.setup {}
require("lspconfig").rust_analyzer.setup {}
