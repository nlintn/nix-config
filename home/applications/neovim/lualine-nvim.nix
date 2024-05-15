{ config }:

with config.colorScheme.palette; /* lua */ ''
  require("battery").setup {}
  local navic = require("nvim-navic")
  
  require("lualine").setup {
    options = {
      theme = 'base16',
    },
    sections = {
      lualine_c = {
        'filename',
        {
          function() return navic.get_location() end,
          cond = navic.is_available,
        },
      },
      lualine_y = {
        'progress',
        'location',
      },
      lualine_z = {
        {
          function () return require("battery").get_status_line() end,
        },
        {
          'datetime',
          style = '%H:%M',
        },
      }
    },
  }
''
