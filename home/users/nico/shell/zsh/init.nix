{ coreutils, lib, ... }:

/* sh */ ''
  local _cmd_base64='${lib.getExe' coreutils "base64"}'
'' + builtins.readFile ./init.zsh
