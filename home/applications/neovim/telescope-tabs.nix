{ fetchFromGitHub, lua51Packages, neovimUtils, writeText }:

neovimUtils.buildNeovimPlugin {
  luaAttr = lua51Packages.buildLuarocksPackage {
    pname = "telescope-tabs";
    version = "scm-1";
    src = fetchFromGitHub {
      owner = "LukasPietzschmann";
      repo = "telescope-tabs";
      rev = "0a678eefcb71ebe5cb0876aa71dd2e2583d27fd3";
      sha256 = "sha256-IvxZVHPtApnzUXIQzklT2C2kAxgtAkBUq3GNxwgPdPY=";
    };
    disabled = lua51Packages.lua.luaversion != "5.1";
    knownRockspec = writeText "telescope-tabs-scm-1.rockspec" ''
      package = "telescope-tabs"
      version = "scm-1"
      source = {
        url = "git://github.com/LukasPietzschmann/telescope-tabs",
      }
      dependencies = {
        "lua == 5.1",
      }
      build = {
        type = "builtin",
        modules = {
          ["telescope-tabs"] = "lua/telescope-tabs.lua",
        },
      }
    '';
  };
  nvimRequiredCheck = "telescope-tabs";
}
