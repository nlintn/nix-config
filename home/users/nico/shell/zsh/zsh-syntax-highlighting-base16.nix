{ config, ... }:

with config.colorScheme.palette;
{
  # main
  comment = "fg=#${base04}";
  alias = "fg=#${base0B}";
  suffix-alias = "fg=#${base0B}";
  global-alias = "fg=#${base0B}";
  function = "fg=#${base0B}";
  command = "fg=#${base0B}";
  precommand = "fg=#${base0B},italic";
  autodirectory = "fg=#${base09},italic";
  single-hyphen-option = "fg=#${base09}";
  double-hyphen-option = "fg=#${base09}";
  back-quoted-argument = "fg=#${base0E}";
  builtin = "fg=#${base0B}";
  reserved-word = "fg=#${base0B}";
  hashed-command = "fg=#${base0B}";
  commandseparator = "fg=#${base0F}";
  command-substitution-delimiter = "fg=#${base05}";
  command-substitution-delimiter-unquoted = "fg=#${base05}";
  process-substitution-delimiter = "fg=#${base05}";
  back-quoted-argument-delimiter = "fg=#${base0F}";
  back-double-quoted-argument = "fg=#${base0F}";
  back-dollar-quoted-argument = "fg=#${base0F}";
  command-substitution-quoted = "fg=#${base0A}";
  command-substitution-delimiter-quoted = "fg=#${base0A}";
  single-quoted-argument = "fg=#${base0A}";
  single-quoted-argument-unclosed = "fg=#${base08}";
  double-quoted-argument = "fg=#${base0A}";
  double-quoted-argument-unclosed = "fg=#${base08}";
  rc-quote = "fg=#${base0A}";
  dollar-quoted-argument = "fg=#${base05}";
  dollar-quoted-argument-unclosed = "fg=#${base08}";
  dollar-double-quoted-argument = "fg=#${base05}";
  assign = "fg=#${base05}";
  named-fd = "fg=#${base05}";
  numeric-fd = "fg=#${base05}";
  unknown-token = "fg=#${base08}";
  path = "fg=#${base0F},underline";
  # path_pathseparator = "fg=#${base0F},underline";
  path_prefix = "fg=#${base0F},underline";
  # path_prefix_pathseparator = "fg=#${base0F},underline";
  globbing = "fg=#${base05}";
  history-expansion = "fg=#${base0E}";
  back-quoted-argument-unclosed = "fg=#${base08}";
  redirection = "fg=#${base05}";
  arg0 = "fg=#${base05}";
  default = "fg=#${base05}";

  #cursor
  cursor = " ";

  # braclet
  cursor-matchingbracket = " ";
}
