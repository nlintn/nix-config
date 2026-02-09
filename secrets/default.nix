lib:

import ./secrets.nix
|> builtins.attrNames
|> builtins.map (
  n: lib.setAttrByPath (lib.removeSuffix ".age" n |> lib.splitString "/") { file = ./${n}; }
)
|> lib.foldl (acc: s: lib.recursiveUpdate acc s) { }
