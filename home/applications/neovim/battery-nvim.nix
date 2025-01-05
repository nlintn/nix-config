{ fetchFromGitHub, lua51Packages, neovimUtils, writeText }:

neovimUtils.buildNeovimPlugin {
  luaAttr = lua51Packages.buildLuarocksPackage {
    pname = "battery.nvim";
    version = "scm-1";
    src = fetchFromGitHub {
      owner = "justinhj";
      repo = "battery.nvim";
      rev = "5b0fc97f8ae29ddd2668eced7f352337d5d07f52";
      sha256 = "sha256-RgCk/BFi8vb6SAq6NchcRm/Lshvvw7hymxGNY0A+M1U=";
    };
    propagatedBuildInputs = [ lua51Packages.plenary-nvim ];
    disabled = lua51Packages.lua.luaversion != "5.1";
    knownRockspec = writeText "battery.nvim-scm-1.rockspec" ''
      package = "battery.nvim"
      version = "scm-1"
      source = {
        url = "git://github.com/justinhj/battery.nvim",
      }
      dependencies = {
        "lua == 5.1",
        "plenary.nvim",
      }
      build = {
        type = "builtin",
        modules = {
          battery = "lua/battery/battery.lua",
        },
        copy_directories = {
          "doc",
          "plugin",
        }
      }
    '';
  };
  nvimRequiredCheck = "battery";
}
