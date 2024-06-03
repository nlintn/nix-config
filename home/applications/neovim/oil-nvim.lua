require("oil").setup {
  experimental_watch_for_changes = true,
}

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
