local battery = require("battery")
battery.setup {}

local navic = require("nvim-navic")
navic.setup {
  lsp = { auto_attach = true, },
  icons = {
    File = ' ',
    Module = ' ',
    Namespace = ' ',
    Package = ' ',
    Class = ' ',
    Method = ' ',
    Property = ' ',
    Field = ' ',
    Constructor = ' ',
    Enum = ' ',
    Interface = ' ',
    Function = ' ',
    Variable = ' ',
    Constant = ' ',
    String = ' ',
    Number = ' ',
    Boolean = ' ',
    Array = ' ',
    Object = ' ',
    Key = ' ',
    Null = ' ',
    EnumMember = ' ',
    Struct = ' ',
    Event = ' ',
    Operator = ' ',
    TypeParameter = ' '
  },
}

require("lualine").setup {
  options = {
    theme = 'base16',
  },
  sections = {
    lualine_a = { 'mode', },
    lualine_b = { 'filename', 'branch', 'diff', 'diagnostics', },
    lualine_c = {
      {
        function() return navic.get_location() end,
        cond = navic.is_available,
      },
    },
    lualine_x = { 'encoding', 'fileformat', 'filetype', },
    lualine_y = { 'progress', 'location', },
    lualine_z = {
      {
        function () return battery.get_status_line() end,
      },
      {
        'datetime',
        style = '%H:%M',
      },
    }
  },
}
