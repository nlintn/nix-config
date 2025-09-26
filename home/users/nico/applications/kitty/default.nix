{ config, options, pkgs, userSettings, ... } @ args:

let
  scrollback_pager = pkgs.writeShellScript "scrollback_pager" ''
    set -eu

    if [ "$#" -eq 3 ]; then
        INPUT_LINE_NUMBER=''${1:-0}
        CURSOR_LINE=''${2:-1}
        CURSOR_COLUMN=''${3:-1}
        AUTOCMD_TERMCLOSE_CMD="call cursor(max([0,''${INPUT_LINE_NUMBER}-1])+''${CURSOR_LINE}, ''${CURSOR_COLUMN})"
    else
        AUTOCMD_TERMCLOSE_CMD="normal G"
    fi

    exec ${config.home.sessionVariables.NVIM} 63<&0 0</dev/null \
        -u NONE \
        -c "map <silent> q :qa!<CR>" \
        -c "set scrollback=100000 laststatus=0 clipboard+=unnamedplus notermguicolors" \
        -c "autocmd TermEnter * stopinsert" \
        -c "autocmd TermClose * ''${AUTOCMD_TERMCLOSE_CMD}" \
        -c 'terminal sed </dev/fd/63 -e "s/'$'\x1b''']8;;file:[^\]*[\]//g" && sleep 0.01 && printf "'$'\x1b''']2;"' 
  '';
in {
  programs.kitty = {
    enable = true;
    package = let
      pkg = options.programs.kitty.package.default;
    in pkgs.symlinkJoin {
      inherit (pkg) name meta;
      paths = [ pkg ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = "wrapProgram $out/bin/kitty --add-flags -1";
    };
    settings = (import ./base16-colors.nix args) // {
      background_opacity = "0.65";
      transparent_background_colors = with config.colorScheme.palette; "#${base02} #${base03}";

      cursor_shape = "beam";
      cursor_blink_interval = 0;
      disable_ligatures = "always";
      scrollback_indicator_opacity = 0.7;

      scrollback_pager = "${scrollback_pager} 'INPUT_LINE_NUMBER' 'CURSOR_LINE' 'CURSOR_COLUMN'";

      mouse_hide_wait = -1;

      enable_audio_bell = "no";
    };
    keybindings = {
      "ctrl+shift+t" = "new_tab_with_cwd";
      "ctrl+shift+n" = "new_os_window_with_cwd";
      "ctrl+shift+enter" = "new_window_with_cwd";
      "ctrl+tab" = "no_op";
      "ctrl+shift+tab" = "no_op";
    };
    font = {
      name = userSettings.default-font.name;
      size = 10.5;
      package = userSettings.default-font.package;
    };
  };
}
