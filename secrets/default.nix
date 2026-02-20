lib:

let
  keys = import ./keys.nix;
  genSecret =
    {
      hosts ? [ ],
      users ? [ ],
    }:
    {
      inherit hosts users;
      publicKeys =
        keys.admin ++ (lib.map (n: keys.hosts.${n}) hosts) ++ (lib.map (n: keys.users.${n}) users);
    };
  genDirSecrets =
    d:
    lib.readDir ./${d}
    |> lib.filterAttrs (_: v: v == "directory")
    |> lib.attrNames
    |> lib.map (
      n:
      lib.readDir ./${d}/${n}
      |> lib.filterAttrs (_: v: v == "regular")
      |> lib.mapAttrs' (
        s: _:
        lib.nameValuePair "${d}/${n}/${s}" (genSecret {
          ${d} = [ n ];
        })
      )
    )
    |> lib.mergeAttrsList;

  secrets =
    lib.mergeAttrsList [
      (genDirSecrets "hosts")
      (genDirSecrets "users")
      (import ./shared |> lib.mapAttrs' (n: v: lib.nameValuePair "shared/${n}" (genSecret v)))
    ]
    |> lib.mapAttrs (
      n: v:
      v
      // {
        file = ./${n};
        secret = lib.removeSuffix ".age" n |> lib.splitString "/" |> lib.last;
      }
    );

  get =
    t: n:
    secrets
    |> lib.filterAttrs (_: v: lib.elem n v.${t})
    |> lib.mapAttrs' (_: v: lib.nameValuePair v.secret { inherit (v) file; });
  hostSecrets = get "hosts";
  userSecrets = get "users";
in
{
  inherit secrets hostSecrets userSecrets;
}
