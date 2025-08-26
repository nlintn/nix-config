function _G.get_oil_winbar()
  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local dir = require("oil").get_current_dir(bufnr)
  if dir then
    return vim.fn.fnamemodify(dir, ":~")
  else
    -- If there is no current directory (e.g. over ssh), just show the buffer name
    return vim.api.nvim_buf_get_name(0)
  end
end

local permission_hlgroups = {
  ['-'] = 'NonText',
  ['r'] = 'DiagnosticSignOk',
  ['w'] = 'DiagnosticSignWarn',
  ['x'] = 'DiagnosticSignError',
}

require("oil").setup {
  default_file_explorer = true,
  columns = {
    {
      'permissions',
      highlight = function(permission_str)
        local hls = {}
        for i = 1, #permission_str do
          local char = permission_str:sub(i, i)
          table.insert(hls, { permission_hlgroups[char], i - 1, i })
        end
        return hls
      end,
    },
    { 'size', highlight = 'Special' },
    { 'mtime', highlight = 'Delimiter' },
    {
      'icon',
      add_padding = true,
    },
  },
  constrain_cursor = "name",
  delete_to_trash = true,
  keymaps = {
    ["<C-CR>"] = { "actions.select", opts = { tab = true } },
  },
  view_options = {
    show_hidden = true,
    is_always_hidden = function(name, _)
      return vim.startswith(name, "..")
    end,
  },
  watch_for_changes = true,
  win_options = {
    winbar = "%!v:lua.get_oil_winbar()",
  },
}
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
