{
  config,
  jail,
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
    package = jail pkgs.opencode (
      with jail.combinators;
      [
        (persist-home "opencode")
        fwd-path
        (add-pkg-deps [
          command-not-found
        ])
        locale
        network
        nix-daemon
        no-new-session
        wayland
        open-urls-in-browser
        time-zone
        (set-env "OPENCODE_DISABLE_FREE_MODELS" "true")
        (set-env "OPENCODE_DISABLE_LSP_DOWNLOAD" "true")
        (readonly "${config.xdg.configHome}/opencode")
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
