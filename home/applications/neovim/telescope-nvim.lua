local tele_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', tele_builtin.find_files, {})
vim.keymap.set('n', '<leader>lg', tele_builtin.live_grep, {})
vim.keymap.set('n', '<leader>gs', tele_builtin.grep_string, {})
vim.keymap.set('n', '<leader>ts', tele_builtin.treesitter, {})
vim.keymap.set('n', '<leader>cmd', tele_builtin.commands, {})

