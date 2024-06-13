require("lsp-zero")
local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(
  function(_, bufnr)
    lsp_zero.default_keymaps({ buffer = bufnr })
  end)

local lspconfig = require("lspconfig")
lspconfig.clangd.setup {}
lspconfig.isabelle.setup {}
lspconfig.jdtls.setup {}
lspconfig.lua_ls.setup {}
lspconfig.nil_ls.setup {}
lspconfig.ocamllsp.setup {}
lspconfig.pyright.setup {}
lspconfig.rust_analyzer.setup {}
lspconfig.texlab.setup {}

