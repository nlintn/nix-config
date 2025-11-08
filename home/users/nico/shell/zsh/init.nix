{ coreutils , lib , ... }:

/* sh */ ''
  local base64='${lib.getExe' coreutils "base64"}'
'' + builtins.readFile ./init.zsh
