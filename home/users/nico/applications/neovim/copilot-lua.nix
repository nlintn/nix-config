{ copilot-language-server, lib, ... }:

/* lua */ ''
  require("copilot").setup {
    suggestion = {
      keymap = {
        accept = "<C-Tab>",
      },
      filetype = {
        oil = false,
      },
    },
    server = {
      type = "binary",
      custom_server_filepath = "${lib.getExe copilot-language-server}",
    },
    server_opts_overrides = {
      settings = {
        telemetry = {
          telemetryLevel = "off",
        },
      },
    },
  }
''
