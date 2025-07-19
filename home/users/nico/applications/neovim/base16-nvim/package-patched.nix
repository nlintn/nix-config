{ pkgs }:

pkgs.vimUtils.buildVimPlugin {
  name = "base16-nvim";
  src = pkgs.fetchFromGitHub {
    owner = "RRethy";
    repo = "base16-nvim";
    rev = "5d0fcd834d48048822e36221ab067bedb3ef5c93";
    hash = "sha256-BqycJYqqCjSGjJSji5HK6IuBaagWhbsY3GBKTUgPsgw=";
  };
  patches = [ ./color-changes.patch ];
}
