require("actions-preview").setup {
  backend = { "telescope" },
}

vim.keymap.set({ "v", "n" }, "<leader>fa", require("actions-preview").code_actions)

