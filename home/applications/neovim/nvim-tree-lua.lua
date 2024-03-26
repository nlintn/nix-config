require("nvim-tree").setup {}

local tree_api = require("nvim-tree.api")
vim.keymap.set('n', '<leader>e', function () tree_api.tree.toggle { focus = false, } end, {} )

