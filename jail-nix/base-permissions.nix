pkgs: combinators: with combinators; [
  base
  (add-pkg-deps [ pkgs.xdg-utils ])
  (readonly "/nix/store")
  (try-ro-bind "/etc/os-release" "/run/host/os-release")
  fake-passwd
]
