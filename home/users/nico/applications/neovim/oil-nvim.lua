require("oil").setup {
  keymaps = {
    ["<C-CR>"] = { "actions.select", opts = { tab = true } },
  },
  view_options = {
    show_hidden = true,
    is_always_hidden = function(name, bufnr)
      return vim.startswith(name, "..")
    end,
  },
}

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
