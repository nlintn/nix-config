{ coreutils
, ...
}:

/* sh */ ''
  local base64='${coreutils}/bin/base64'
'' + builtins.readFile ./init.zsh
