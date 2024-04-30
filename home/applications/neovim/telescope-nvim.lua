local actions = require("telescope").extensions.file_browser.actions
local telescope_actions = require("telescope.actions.state")
local oil = require("oil")

require("telescope").setup {
  extensions = {
    file_browser = {
      mappings = {
        ["i"] = {
          ["<C-u>"] = function(prompt_bufnr)
            local entry = telescope_actions.get_selected_entry()
            --  actions.close(prompt_bufnr)
            oil.open(entry.path)
          end,
        }
      }
    }
  }
}

local tele_builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', tele_builtin.find_files, {})
vim.keymap.set('n', '<leader>fb', tele_builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', tele_builtin.help_tags, {})
vim.keymap.set('n', '<leader>lg', tele_builtin.live_grep, {})
vim.keymap.set('n', '<leader>gs', tele_builtin.grep_string, {})
vim.keymap.set('n', '<leader>ts', tele_builtin.treesitter, {})
vim.keymap.set('n', '<leader>cmd', tele_builtin.commands, {})
vim.keymap.set('n', '<leader>ls', tele_builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>lr', tele_builtin.lsp_references, {})
vim.keymap.set('n', '<leader>li', tele_builtin.lsp_implementations, {})
vim.keymap.set('n', '<leader>ld', tele_builtin.lsp_type_definitions, {})

require("telescope").load_extension("file_browser")
local tele_ext = require('telescope').extensions
vim.keymap.set('n', '<leader>fd', tele_ext.file_browser.file_browser, {})

