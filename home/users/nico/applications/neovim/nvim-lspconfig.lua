vim.keymap.set('n', 'K', function() vim.lsp.buf.hover { border = 'single', } end, {})
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
vim.keymap.set('n', 'gl', function() vim.diagnostic.open_float { border = 'single', } end, {})
vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, {})

vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)

vim.keymap.set('i', '<C-s>', function() vim.lsp.buf.signature_help { border = 'single', } end, {})
vim.keymap.set('v', '<C-s>', function() vim.lsp.buf.signature_help { border = 'single', } end, {})

vim.diagnostic.config { virtual_text = true, --[[ virtual_lines = { current_line = true } ]]}

vim.lsp.enable('clangd')
vim.lsp.enable('cssls')
vim.lsp.enable('eslint')
vim.lsp.enable('html')
vim.lsp.enable('isabelle')
vim.lsp.enable('jdtls')
vim.lsp.enable('jsonls')
vim.lsp.enable('lua_ls')
vim.lsp.enable('nixd')
vim.lsp.enable('ocamllsp')
vim.lsp.enable('pyright')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('texlab')
vim.lsp.enable('ts_ls')
