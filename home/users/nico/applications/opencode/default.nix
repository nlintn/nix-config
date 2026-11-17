{
  config,
  lib,
  pkgs,
  ...
}:

let
  deepseekApiKey = config.age.secrets."opencode-deepseek_api".path;
  morpheusApiKey = config.age.secrets."opencode-morpheus_api".path;

  agent-stuff = pkgs.fetchFromGitHub {
    owner = "0xferrous";
    repo = "agent-stuff";
    rev = "6f4c819eaaad22c9dd86b5e0cf920952e39de6a1";
    hash = "sha256-OeVS9NSTZbMDUObfnaTaJioQtnE2nbdhwD2IwLnBSJo=";
  };

  command-not-found =
    let
      dbPath = pkgs.path + "/programs.sqlite";
    in
    if lib.pathExists dbPath then
      pkgs.replaceVarsWith {
        name = "command-not-found";
        dir = "bin";
        src = "${pkgs.path}/nixos/modules/programs/command-not-found/command-not-found.pl";
        isExecutable = true;
        replacements = {
          inherit dbPath;
          perl = pkgs.perl.withPackages (p: [
            p.DBDSQLite
            p.StringShellQuote
          ]);
        };
      }
    else
      pkgs.nix-index;
in
{
  programs.opencode = {
    enable = true;
    package = pkgs.jail pkgs.opencode (
      combinators: with combinators; [
        (base-xdg "ai.opencode.opencode")
        (add-pkg-deps [ command-not-found ])
        (readonly "/etc/group")
        (readonly "/etc/passwd")
        (set-env "OPENCODE_DISABLE_FREE_MODELS" "true")
        (set-env "OPENCODE_DISABLE_LSP_DOWNLOAD" "true")
        fwd-path
        locale
        network
        nix-daemon
        no-new-session
        time-zone
        wayland
        persist-base-dirs
        (mount-home-dir config.xdg.configFile "opencode")
        (readonly deepseekApiKey)
        (readonly morpheusApiKey)
        mount-cwd
      ]
    );
    settings = {
      model = "deepseek/deepseek-flash";
      providers = import ./providers.nix {
        inherit
          deepseekApiKey
          morpheusApiKey
          ;
      };
      lsp = true;
    };
    cli = {
      theme = {
        name = "system";
        mode = "system";
      };
      animations = false;
      cursor = {
        style = "line";
        blinking = false;
      };
      prompt = {
        paste = "full";
        image_preview = true;
      };
      session = {
        sidebar = "auto";
        scrollbar = true;
        thinking = "show";
        image_preview = true;
      };
      keybinds = {
        leader = "ctrl+b";
      };
      debug.turn_tokens = "verbose";
    };
    skills = {
      nix-search = "${agent-stuff}/skills/nix-search/SKILL.md";
    };
    validateFiles = {
      cli = true;
      config = true;
    };
  };

  xdg.configFile."opencode/AGENTS.md".source = ./AGENTS.md;
  xdg.configFile."opencode/service.json".text = lib.toJSON { disabled = true; };
}
