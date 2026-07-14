{
  lib,
  ...
}@args:

lib.mkMerge (
  (lib.map (f: import f args) [
    ./fzf-tab-preview.nix
  ])
  ++ (lib.map lib.readFile [
    ./binds.zsh
    ./clipboard.zsh
    ./style.zsh
    ./cursor.zsh
  ])
)
