{
  config,
  lib,
  lib-custom,
  pkgs,
  ...
}:

let
  inherit (lib-custom.term)
    fg
    fgBold
    set
    reset
    ;

  bat = "${lib.getExe config.programs.bat.package} --paging=never --color=always";
  bat_man = "${bat} -lman --style grid";
  eza = lib.getExe pkgs.eza;
  git = lib.getExe config.programs.git.package;
  head = lib.getExe' pkgs.coreutils "head";
  man = lib.getExe config.programs.man.package;
  mktemp = lib.getExe' pkgs.coreutils "mktemp";
  nix = lib.getExe config.nix.package;
  realpath = lib.getExe' pkgs.coreutils "realpath";

  header = "builtin set -o pipefail && tmp_err=\"$(${mktemp})\" && words_pre=\" \${words}\" && words_trim=\"\${words_pre% *} \" && builtin echo \"${fgBold "magenta"}\${group:-[command]}${reset}\\n ${fg "cyan"}↳\${words_trim}${
    set {
      fg = "green";
      mods = [ "italic" ];
    }
  }\${realpath:-\${word}}\\n${reset}\"";

  previewCmds = {
    "git:*" = [ "${git} help \"\${word}\" | ${bat_man}" ];
    "man:*" = [ "${man} \"\${word}\" | ${bat_man}" ];
    "nix:*" = [
      "${nix} help \"\${word}\""
      "${nix} eval --raw \"\${word}\" --apply 'x: with x.meta; \"name:       \\t\${name}\\ndescription:\\t\${description}\\nhomepage:   \\t\${homepage}\\n\"'"
    ];
  };
  fallbackCmds = [
    "fullpath=\"$(${realpath} -e \"\${realpath}\" || ${realpath} -e \"\${realpath#*=}\")\" 2>/dev/null && (${bat} \"\${fullpath}\" 2>/dev/null || ${eza} --color=always --follow-symlinks --tree \"\${fullpath}\")"
    "echo \"${fgBold "green"}Description:${reset}\\n${fg "green"}\${desc}${reset}\""
  ];

  command = ctx: style: "builtin zstyle ':fzf-tab:${ctx}' fzf-preview ${lib.escapeShellArg style}";
  commandComplete = ctx: command "complete:${ctx}";

  format =
    cmds:
    "{"
    + header
    + "} && {{"
    + (
      lib.map (c: "{ :>\${tmp_err} && out=$(${c}) 2>\${tmp_err} }") (cmds ++ fallbackCmds)
      |> lib.concatStringsSep " || "
    )
    + "} && <<< \${out} && < \${tmp_err} >&2} | ${head} -97; rm \${tmp_err}";
in
lib.concatStringsSep "\n" (
  [
    (command "*" (format [ ]))
  ]
  ++ lib.mapAttrsToList (n: v: commandComplete n (format v)) previewCmds
)
